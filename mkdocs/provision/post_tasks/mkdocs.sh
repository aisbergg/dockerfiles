#!/bin/bash

# exit on errors
set -e

chmod +x /home/mkdocs/build_site.sh

# set SSH-Key permissions
chgrp www-data "$GIT_SSH_KEY"
chmod 440 "$GIT_SSH_KEY"

# building the site for the first time
su mkdocs -c "ssh-agent /home/mkdocs/build_site.sh >/dev/null"
