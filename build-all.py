#!/usr/bin/env python

import os
from subprocess import call

dockerfiles = [
    {'path': 'base/release/Dockerfile-Alpine', 'name': 'aisberg/base-alpine', 'tag': '3.8', 'pull': True},
    {'path': 'base/release/Dockerfile-Ubuntu', 'name': 'aisberg/base-ubuntu', 'tag': '18.04', 'pull': True},
    {'path': 'burp/Dockerfile', 'name': 'aisberg/burp', 'tag': '2.2.12'},
    {'path': 'nginx/Dockerfile', 'name': 'aisberg/nginx', 'tag': 'latest'},
    {'path': 'nginx-node/release/Dockerfile-Node-11', 'name': 'aisberg/nginx-node', 'tag': '11'},
    {'path': 'nginx-php5/Dockerfile', 'name': 'aisberg/nginx-php5', 'tag': 'latest'},
    {'path': 'nginx-php7/Dockerfile', 'name': 'aisberg/nginx-php7', 'tag': 'latest'},
    {'path': 'concrete5/Dockerfile', 'name': 'aisberg/concrete5', 'tag': '8.4.2'},
    {'path': 'dokuwiki/Dockerfile', 'name': 'aisberg/dokuwiki', 'tag': '2018-04-22'},
    {'path': 'etherpad/Dockerfile', 'name': 'aisberg/etherpad', 'tag': '1.7.0'},
    {'path': 'gitea/Dockerfile', 'name': 'aisberg/gitea', 'tag': '1.6.0'},
    {'path': 'grav/Dockerfile', 'name': 'aisberg/grav', 'tag': 'latest'},
    {'path': 'html/Dockerfile', 'name': 'aisberg/html', 'tag': 'latest'},
    {'path': 'haproxy/Dockerfile', 'name': 'aisberg/haproxy', 'tag': '1.8.14'},
    {'path': 'html-php5/Dockerfile', 'name': 'aisberg/html-php5', 'tag': 'latest'},
    {'path': 'html-php7/Dockerfile', 'name': 'aisberg/html-php7', 'tag': 'latest'},
    {'path': 'limesurvey/Dockerfile', 'name': 'aisberg/limesurvey', 'tag': '3.15.0'},
    {'path': 'mediawiki/Dockerfile', 'name': 'aisberg/mediawiki', 'tag': '1.31.1'},
    {'path': 'mumble-server/Dockerfile', 'name': 'aisberg/mumble-server', 'tag': '1.2.19'},
    {'path': 'nextcloud/Dockerfile', 'name': 'aisberg/nextcloud', 'tag': '14.0.3'},
    {'path': 'phpbb/Dockerfile', 'name': 'aisberg/phpbb', 'tag': '3.2.3'},
    {'path': 'phplist/Dockerfile', 'name': 'aisberg/phplist', 'tag': '3.3.5'},
    {'path': 'phpmyadmin/Dockerfile', 'name': 'aisberg/phpmyadmin', 'tag': '4.8.4'},
    {'path': 'redis/Dockerfile', 'name': 'aisberg/redis', 'tag': 'latest'},
    {'path': 'teamspeak-server/Dockerfile', 'name': 'aisberg/teamspeak-server', 'tag': '3.5.0'},
    {'path': 'wordpress/Dockerfile', 'name': 'aisberg/wordpress', 'tag': '4.9.8'},
]

cwd = os.getcwd()
for df in dockerfiles:
    print("Building {}...".format(df['name']))
    tags = ['latest']
    if 'tag' in df and df['tag'] != 'latest':
        tags += [df['tag']]
    cmd = ["docker", "build"]
    for tag in tags:
        cmd += ['-t', '{0}:{1}'.format(df['name'], tag)]
    if 'pull' in df and df['pull']:
        cmd += ['--pull']
    cmd += ['-f', os.path.basename(df['path']), '.']

    os.chdir(os.path.dirname(df['path']))
    if call(cmd) != 0:
        exit(1)
    os.chdir(cwd)
    print("\n")
