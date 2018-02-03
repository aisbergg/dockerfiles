#!/bin/bash
set -eo pipefail

print_info "Configuring MariaDB"

# prepare parameter
case "$(lower_case "$CONFIG")" in
    tiny|small|medium|large|huge|custom)
        export CONFIG="$(lower_case "$CONFIG")"
        ;;
    *)
        export CONFIG=medium
        ;;
esac

DATADIR=/var/lib/mysql

if [ ! -d "$DATADIR/mysql" ]; then
    # check if all keys were supplied
    if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
        print_error "To initialize MariaDB the 'MYSQL_ROOT_PASSWORD' must be specified!"
        exit 1
    fi

    mkdir -p "$DATADIR"
    chown -R mysql:mysql "$DATADIR"

    print_info 'Initializing database'
    mysql_install_db --datadir="$DATADIR" --rpm --user=mysql
    print_info 'Database initialized'

    mysqld --user=mysql --datadir="$DATADIR" --skip-networking &
    pid="$!"

    mysql=( mysql --protocol=socket -uroot -hlocalhost )

    for i in {30..0}; do
        if echo 'SELECT 1' | "${mysql[@]}" &> /dev/null; then
            break
        fi
        print_info 'MariaDB init process in progress...'
        sleep 1
    done
    if [ "$i" = 0 ]; then
        print_error 'MariaDB init process failed.'
        exit 1
    fi

    mysql_tzinfo_to_sql /usr/share/zoneinfo | sed 's/Local time zone must be set--see zic manual page/FCTY/' | "${mysql[@]}" mysql

    "${mysql[@]}" <<-EOSQL
        -- What's done in this file shouldn't be replicated
        --  or products like mysql-fabric won't work
        SET @@SESSION.SQL_LOG_BIN=0;
        DELETE FROM mysql.user ;
        CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;
        GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ;
        DROP DATABASE IF EXISTS test ;
        FLUSH PRIVILEGES ;
EOSQL

    if ! kill -s TERM "$pid" || ! wait "$pid"; then
        print_error 'MariaDB init process failed.'
        exit 1
    fi
fi

# set owner to mysql
chown -R mysql:mysql "$DATADIR"
unset DATADIR
