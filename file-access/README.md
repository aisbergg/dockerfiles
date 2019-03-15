# File-Access (aisberg/file-access)

Definition file structure:
```yaml
# global default values
defaults:
  # defaults for owner and group of the directory
  owner_permissions: rwx
  owner_group_permissions: rwx
  # defaults for following 'users' and 'groups' sections
  user_permissions: rwx
  group_permissions: rwx

# definition of Linux groups
groups:
  web:                          # name of the group
    gid: 10001                  # group id (optional)
    permissions:                # dir permissions of this group (optional)
      - path: /apps/blog        # a directory path
        permissions: rx         # directory permissions (optional; default: 'group_permissions')
        recursive: true         # set ACLs recursively (optional; default: true)
      - path: /apps/wiki

# definition of Linux users
users:
  foo:                          # name of the user
    uid: 1000                   # user id (optinal)
    groups:                     # groups the user belongs to
      - web
    home: /home/foo             # path of home directory (optinal)
    ssh_public_key: "ssh-rsa..." # SSH public key (optinal)
    password: "xyz"             # SSH password; plain text (optinal)
    permissions:                # dir permissions of this user (optional)
      - path: /apps/nextcloud   # a directory path
        permissions: rwx        # directory permissions (optional; default: 'user_permissions')
        recursive: false        # set ACLs recursively (optional; default: true)
```
