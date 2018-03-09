#!/bin/bash

clear
prthdl SUCCESS "Welcome, good to see you again!"

echo "
$(tput setaf 4)Notes
=====$(tput sgr0)
Here you have access to the files of all web services run by your organisations. The files are stored in the common location, so you will be able to find them easily:
 - Static and dynamic web-apps: /var/www
 - Self contained apps: /opt/
 - Other dynamic data: /var/lib

All services are run in seperated docker containers (this SSH access too), and therefore you won't be able to control the services itself. This SSH lives in a 'virtual' file system, so newly created files are not stored persistently and after a container recreation those files will be lost. To store files persistently you have to use the persistent volumes mounted into this container. Those volumes are: $(echo ${PERSISTENT_DIRS} | sed -e 's/;/  /g')
Just be sure you do not created files outside the provided volumes and everything is fine. It should not bother you, but due some limitations more persistent files and dirs are specified in \`/root/container-keep-files/filelist\`. Only if it's really necessary more persistent dirs can be specified there.

$(tput setaf 3)Important
=========$(tput sgr0)
This is a production environment and should therefore not be used for development, testing or experiments!
"

# print last login time
last_login_time="$(last -i $USER | grep -v 'still logged' | head -n 1 | cut -c 40-)"
if [ -n "${last_login_time}" ]; then
    echo "Your last login: $last_login_time
"
fi
unset last_login_time
