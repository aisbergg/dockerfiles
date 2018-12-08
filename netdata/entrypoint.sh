#!/bin/bash

if [[ -f /etc/container_environment ]]; then
    source /etc/container_environment
fi

if [[ -n "$SMTP_HOST" ]]; then
    echo "Configuring SMTP client"

    SMTP_HOST="$SMTP_HOST"
    SMTP_PORT="${SMTP_PORT:-465}"
    SMTP_AUTHMETHOD="${SMTP_AUTHMETHOD:-plain}"
    SMTP_USER="${SMTP_USER}"
    SMTP_PASSWORD="${SMTP_PASSWORD}"
    SMTP_TLS="${SMTP_TLS:-TLS}"
    SMTP_FROM="${SMTP_FROM}"

    # configure SMTP client
cat > /etc/msmtprc <<EOF
# msmtprc configuration file
# documentation: http://msmtp.sourceforge.net/doc/msmtp.html

defaults
protocol smtp

host $SMTP_HOST
port $SMTP_PORT
auth $SMTP_AUTHMETHOD
user $SMTP_USER
password $SMTP_PASSWORD
tls $(if [[ "$SMTP_TLS" != off ]]; then echo on ; else echo off ; fi)
tls_starttls $(if [[ "$SMTP_TLS" == STARTTLS ]]; then echo on ; else echo off ; fi)
tls_trust_file /etc/ssl/certs/ca-certificates.crt

from $SMTP_FROM

account default
EOF
    chmod 640 /etc/msmtprc
    chown root:netdata /etc/msmtprc
fi

# execute Netdata
exec /usr/sbin/run.sh
