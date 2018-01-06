# Docker Mattermost (aisberg/mattermost)

Dockerfile to build a [Mattermost](https://www.mattermost.org/) container image.

# Setup

Database collation utf8_unicode_ci

## Arguments

[*Mttermost* documentation](http://docs.mattermost.com/administration/config-settings.html)

| Argument                     | Description                                                       | Default Value |
|------------------------------|-------------------------------------------------------------------|---------------|
| SQLSETTINGS_DRIVERNAME       | Name of the database driver to use. (mysql or postgres)           | mysql         |
| SQLSETTINGS_DATABASEHOST     | Hostname of the database.                                         | mysql         |
| SQLSETTINGS_DATABASENAME     | Name of the database to use.                                      | mattermost    |
| SQLSETTINGS_DATABASEUSER     | User for accessing the database                                   | mattermost    |
| SQLSETTINGS_DATABASEPASSWORD | Password for authentication                                       |               |
| SQLSETTINGS_DATABASEPORT     | Port for connecting to the database                               | 3306          |
| SQLSETTINGS_DATABASETLS      | Use TLS for database connection or not (true, false, skip-verify) | false         |
