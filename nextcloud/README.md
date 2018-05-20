# Nextcloud (aisberg/nextcloud)

## Features
...
    Based on Alpine Linux.
    Bundled with nginx and PHP 7.1 (wonderfall/nginx-php image).
    Automatic installation using environment variables.
    Package integrity (SHA512) and authenticity (PGP) checked during building process.
    Data and apps persistence.
    OPCache (opcocde), APCu (local) installed and configured.
    system cron task running.
    MySQL, PostgreSQL (server not built-in) and sqlite3 support.
    Redis, FTP, SMB, LDAP, IMAP support.
    GNU Libiconv for php iconv extension (avoiding errors with some apps).
    No root processes. Never.
    Environment variables provided (see below).
