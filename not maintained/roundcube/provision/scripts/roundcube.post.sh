#!/bin/bash

unset DES_KEY

if [ "$COMPLETE_INSTALLATION" == True ]; then
    pushd /var/www/roundcube 1>/dev/null
    # init database
    php ./bin/initdb.sh --dir=./SQL
    popd 1>/dev/null
    unset COMPLETE_INSTALLATION
fi

chown -R www-data /var/www/roundcube
