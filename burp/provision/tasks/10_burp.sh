#!/bin/bash
set -e

export BURP_MODE=$(default "$BURP_MODE" client server)
export MYSQL_DATABASES=${MYSQL_DATABASES:-""}

print_info "Configuring Burp in '$BURP_MODE' mode"

if [[ "$BURP_MODE" == server ]]; then
    mkdir -p \
        /container/burp/clientconfdir \
        /container/tls \
        /container/backup

    export INIT=supervisor
    export BURP_SERVER_SSL_DHFILE=${BURP_SERVER_SSL_DHFILE:-"/container/tls/dhfile.pem"}

    if [[ ! -f "$BURP_SERVER_SSL_DHFILE" ]] ; then
    	openssl dhparam -dsaparam -out "$BURP_SERVER_SSL_DHFILE" 4096
    	chmod 600 "$BURP_SERVER_SSL_DHFILE"
    fi

elif [[ "$BURP_MODE" == client ]]; then
    mkdir -p \
        /container/burp \
        /container/tls

    BURP_CLIENT_SCHEDULE=${BURP_CLIENT_SCHEDULE:-20}
    export INIT=tini
    export INIT_ARGS=( /usr/bin/schedule_program --minutes $BURP_CLIENT_SCHEDULE --wake-up 60 -- /usr/sbin/burp -a t -c /container/burp/burp.conf )
fi
