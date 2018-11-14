import argparse
import crypt
import json
import os
import pwd
import random
import re
import string
import subprocess
import sys
import traceback
from itertools import product

import yaml


class ACL:

    @staticmethod
    def get_file_acl(path):
        if not os.path.exists(path):
            raise IOError("The directory or file '{0}' does not exist".format(path))
        cmd_result = execute_command(['getfacl', '-p', path])
        if cmd_result['returncode'] != 0:
            raise Exception("Failed to get ACL of file or directory '{0}': {1}".format(path, cmd_result['output']))

        raw_acl = cmd_result['output'].splitlines()

        owner = re.match(r'# owner: (.+)', raw_acl[1]).group(1)
        group = re.match(r'# group: (.+)', raw_acl[2]).group(1)

        acl = {'users': [], 'groups': [], 'other': None}
        for a in raw_acl[3:]:
            match_acl = re.match(r'user::([rwx-]+)', a)
            if match_acl:
                acl['users'].append({'name': '', 'permissions': match_acl.group(1)})
                # explicitly add owner (e.g. webserver), so sub directories created
                # by different user will still be readable by the original owner
                acl['owner'] = {'name': owner, 'permissions': match_acl.group(1)}
                continue

            match_acl = re.match(r'user:([^:]+):([rwx-]+)', a)
            if match_acl:
                acl['users'].append({'name': match_acl.group(1), 'permissions': match_acl.group(2)})
                continue

            match_acl = re.match(r'group::([rwx-]+)', a)
            if match_acl:
                acl['groups'].append({'name': '', 'permissions': match_acl.group(1)})
                acl['group'] = {'name': group, 'permissions': match_acl.group(1)}
                continue

            match_acl = re.match(r'group:([^:]+):([rwx-]+)', a)
            if match_acl:
                acl['groups'].append({'name': match_acl.group(1), 'permissions': match_acl.group(2)})
                continue

            match_acl = re.match(r'other::([rwx-]+)', a)
            if match_acl:
                acl['other'] = match_acl.group(1)
                continue

        return acl

    @staticmethod
    def file_acl_differs(path, new_acl):
        old_acl = ACL.get_file_acl(path)
        return json.dumps(old_acl, sort_keys=True) != json.dumps(new_acl, sort_keys=True)

    @staticmethod
    def set_file_acl(path, new_acl, force=False):
        def format_acl_spec(prefix, name, permissions):
            acl_spec = list()
            acl_spec.append("{0}:{1}:{2}".format(prefix, name, permissions))
            if os.path.isdir(path):
                acl_spec.append("d:{0}:{1}:{2}".format(prefix, name, permissions))
            return ','.join(acl_spec)

        old_acl = ACL.get_file_acl(path)
        if force or json.dumps(old_acl, sort_keys=True) != json.dumps(new_acl, sort_keys=True):
            print("Setting ACLs of '{0}...".format(path))
            # modify ACLs
            setfacl_cmd = ['setfacl', '-R', '-m']
            acl_spec = list()
            for uacl in new_acl['users']:
                acl_spec.append(format_acl_spec('u', uacl['name'], uacl['permissions']))
            # explicitly add owner (e.g. webserver), so sub directories created
            # by different user will still be readable by the original owner
            acl_spec.append(format_acl_spec('u', new_acl['owner']['name'], new_acl['owner']['permissions']))
            for gacl in new_acl['groups']:
                acl_spec.append(format_acl_spec('g', gacl['name'], gacl['permissions']))
            acl_spec.append(format_acl_spec('g', new_acl['group']['name'], new_acl['group']['permissions']))
            acl_spec.append(format_acl_spec('o', '', new_acl['other']))
            setfacl_cmd.append(','.join(acl_spec))
            setfacl_cmd.append(path)

            cmd_result = execute_command(setfacl_cmd)
            if cmd_result['returncode'] != 0:
                raise Exception("Failed to set ACL of file or directory '{0}': {1}".format(path, cmd_result['output']))

            # remove ACLs
            setfacl_cmd = ['setfacl', '-R', '-x']
            acl_spec = list()
            users_to_remove = list(
                set([x['name'] for x in old_acl['users']]) - set([x['name'] for x in new_acl['users']]))
            groups_to_remove = list(
                set([x['name'] for x in old_acl['groups']]) - set([x['name'] for x in new_acl['groups']]))
            for u in users_to_remove:
                acl_spec.append(format_acl_spec('u', u, ''))
            for g in groups_to_remove:
                acl_spec.append(format_acl_spec('g', g, ''))
            if acl_spec:
                setfacl_cmd.append(','.join(acl_spec))
                setfacl_cmd.append(path)

                cmd_result = execute_command(setfacl_cmd)
                if cmd_result['returncode'] != 0:
                    raise Exception(
                        "Failed to remove ACL from file or directory '{0}': {1}".format(path, cmd_result['output']))


def get_arg(config, arg, dtype, default=None, required=False):
    if required and not arg in config:
        raise ValueError("Missing key '{0}'".format(arg))
    if not arg in config:
        return default
    if type(config[arg]) is not dtype:
        raise ValueError("'{0}' must be of type '{1}', got '{2}'".format(arg, str(dtype), str(config[arg])))
    return config[arg]


def execute_command(cmd):
    try:
        return {'returncode': 0,
                'output': subprocess.check_output(cmd, stderr=subprocess.STDOUT, universal_newlines=True)}
    except subprocess.CalledProcessError as e:
        return {'returncode': e.returncode, 'output': e.output}


def recursive_chown(path, uid, gid):
    os.chown(path, uid, gid)
    for item in os.listdir(path):
        itempath = os.path.join(path, item)
        if os.path.isfile(itempath):
            os.chown(itempath, uid, gid)
        elif os.path.isdir(itempath):
            os.chown(itempath, uid, gid)
            recursive_chown(itempath, uid, gid)


def main():
    # parse arguments
    parser = argparse.ArgumentParser(
        prog='setup-users-and-groups',
        description='According to a configuration file this script creates Linux users/groups and grants permissions on resources.',
        add_help=True)
    parser.add_argument('-f', '--force', dest='force',
                        action='store_true', default=False, help="Force the setting the ACLs.")
    parser.add_argument('-c', '--create-dir', dest='create_dir',
                        action='store_true', default=False, help="Create a directory for a path that does not exists.")
    parser.add_argument('configuration_file', help="File that defines what to do.")
    args = parser.parse_args(sys.argv[1:])

    try:
        # load configuration either from file or from stdin
        if args.configuration_file == '-':
            inp = sys.stdin.read()
            config = yaml.load(inp) or dict()
        else:
            if not os.path.exists(args.configuration_file):
                raise IOError("The configuration file '{0}' does not exist".format(args.configuration_file))
            with open(file=args.configuration_file, mode='r', encoding='utf8') as f:
                config = yaml.load(f.read())

        # parse arguments
        groups = get_arg(config, "groups", dict, dict())
        users = get_arg(config, "users", dict, dict())
        defaults = get_arg(config, "defaults", dict, None) or dict()
        defaults = {
            'owner_permissions': get_arg(defaults, "owner_permissions", str, None),
            'owner_group_permissions': get_arg(defaults, "owner_group_permissions", str, None),
            'user_permissions': get_arg(defaults, "user_permissions", str, 'rwx'),
            'group_permissions': get_arg(defaults, "group_permissions", str, 'rwx'),
        }

        acls = dict()

        # create groups
        for group, gdef in groups.items():
            if type(gdef) != dict:
                raise ValueError("The group definition of '{0}' must be of type dict".format(group))
            gid = get_arg(gdef, 'gid', int, None)
            permissions = get_arg(gdef, 'permissions', list, list())

            # add group if it doesn't already exists
            if execute_command(['getent', 'group', group])['returncode'] == 0:
                print("Group '{0}' already exists, skipping...".format(group))
            else:
                print("Creating group '{0}'...".format(group))
                groupadd_cmd = ['groupadd']
                if gid:
                    groupadd_cmd += ['-g', str(gid)]
                groupadd_cmd.append(group)

                cmd_result = execute_command(groupadd_cmd)
                if cmd_result['returncode'] != 0:
                    raise Exception("Failed to create group '{0}': {1}".format(group, cmd_result['output']))

            # parse permissions
            for perm in permissions:
                path = get_arg(perm, "path", str, None, required=True)
                if not os.path.exists(path):
                    if args.create_dir:
                        os.makedirs(path, 0o750);
                    else:
                        raise IOError("The directory or file '{0}' does not exist".format(path))
                path_permissions = get_arg(perm, 'permissions', str, defaults['group_permissions'])
                new_acl = {'name': group, 'permissions': path_permissions}
                if path in acls:
                    acls[path]['groups'].append(new_acl)
                else:
                    user_group_default = {'name': '', 'permissions': defaults['group_permissions']}
                    acls[path] = {'users': [user_group_default], 'groups': [user_group_default, new_acl],
                                  'other': '---'}

        # create users
        for user, udef in users.items():
            if type(udef) != dict:
                raise ValueError("The user definition of '{0}' must be of type dict".format(user))
            uid = get_arg(udef, 'uid', int, None)
            groups = get_arg(udef, 'groups', list, None)
            home = get_arg(udef, 'home', str, None)
            random_string = ''.join(
                random.SystemRandom().choice(string.ascii_letters + string.digits) for _ in range(64))
            hashed_password = crypt.crypt(get_arg(udef, 'password', str, random_string),
                                          crypt.mksalt(crypt.METHOD_SHA512))
            ssh_public_key = get_arg(udef, 'ssh_public_key', str, '')
            permissions = get_arg(udef, 'permissions', list, list())

            # add user if it doesn't already exists
            if execute_command(['getent', 'passwd', user])['returncode'] == 0:
                print("User '{0}' already exists, skipping...".format(user))
            else:
                print("Creating user '{0}'...".format(user))
                useradd_cmd = ['useradd', '-m', '-p', hashed_password, '-U', '-s', '/bin/bash']
                if uid:
                    useradd_cmd += ['-u', str(uid)]
                if groups:
                    useradd_cmd += ['-G', ','.join(groups)]
                if home:
                    useradd_cmd += ['-d', home]
                useradd_cmd.append(user)

                cmd_result = execute_command(useradd_cmd)
                if cmd_result['returncode'] != 0:
                    raise Exception("Failed to create user '{0}': {1}".format(user, cmd_result['output']))

            # set SSH public key
            user_info = pwd.getpwnam(user)
            ak_file = os.path.join(user_info.pw_dir, '.ssh/authorized_keys')
            authorized_key_string = "## !!! DO NOT EDIT THIS FILE !!!\n## This file is generated automatically. Any changes will eventually be lost.\n## If you like to add a SSH Public Key contact your administrator.\n" + ssh_public_key
            os.makedirs(os.path.dirname(ak_file), 0o750, True)
            with open(file=ak_file, mode='w', encoding='utf8') as f:
                f.write(authorized_key_string)
            os.chmod(ak_file, 0o400)
            recursive_chown(user_info.pw_dir, user_info.pw_uid, user_info.pw_gid)

            # parse permissions
            for perm in permissions:
                path = get_arg(perm, "path", str, None, required=True)
                if not os.path.exists(path):
                    if args.create_dir:
                        os.makedirs(path, 0o750)
                    else:
                        raise IOError("The directory or file '{0}' does not exist".format(path))
                path_permissions = get_arg(perm, 'permissions', str, defaults['user_permissions'])
                new_acl = {'name': user, 'permissions': path_permissions}
                if path in acls:
                    acls[path]['users'].append(new_acl)
                else:
                    user_group_default = {'name': '', 'permissions': defaults['user_permissions']}
                    acls[path] = {'users': [user_group_default, new_acl], 'groups': [user_group_default],
                                  'other': '---'}

        # set ACLs
        paths = list(acls.keys())
        paths.sort()
        # find prefix paths and append permissions, otherwise longer paths will overwrite the shorter paths permissions
        for p1, p2 in product(paths, paths):
            if p1 != p2 and p2.startswith(p1):
                acls[p2]['users'] += acls[p1]['users']
                acls[p2]['groups'] += acls[p1]['groups']
        for path in paths:
            old_acl = ACL.get_file_acl(path)
            acls[path]['owner'] = {'name': old_acl['owner']['name'], 'permissions': defaults['owner_permissions'] or old_acl['owner']['permissions']}
            acls[path]['group'] = {'name': old_acl['group']['name'], 'permissions': defaults['owner_group_permissions'] or old_acl['group']['permissions']}
            ACL.set_file_acl(path, acls[path], args.force)

    except Exception as e:
        sys.stderr.write(str(e) + '\n\n')
        traceback.print_exc(5)
        exit(1)


if __name__ == '__main__':
    main()
