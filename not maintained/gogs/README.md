![Maintenance](https://img.shields.io/maintenance/yes/2018.svg) ![gogs 0.11.29](https://img.shields.io/badge/gogs-0.11.34-brightgreen.svg) [![License MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/Aisbergg/docker-gogs/blob/master/LICENSE)

# Gogs (aisberg/gogs)

<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Gogs (aisberg/gogs)](#gogs-aisberggogs)
	- [Features](#features)
	- [What is this software? Description, Website, Repo](#what-is-this-software-description-website-repo)
	- [What version is it?](#what-version-is-it)
	- [Image description tweak it how you want it, shit load of arguments for fine tuning and reasonable default values](#image-description-tweak-it-how-you-want-it-shit-load-of-arguments-for-fine-tuning-and-reasonable-default-values)
	- [How to Build](#how-to-build)
	- [How to start](#how-to-start)
	- [What about the data](#what-about-the-data)
- [Arguments](#arguments)
	- [Arguments](#arguments)
	- [License](#license)
		- [Gogs](#gogs)
		- [Nginx](#nginx)

<!-- /TOC -->

## Features

## What is this software? Description, Website, Repo
## What version is it?

## Image description tweak it how you want it, shit load of arguments for fine tuning and reasonable default values

## How to Build
## How to start
## What about the data


# Arguments
  Default values
  what is required
  more arguments in base images
  what are important ones
  mandatory ones

## Arguments

Alle Argumente sind optional und werden, falls nicht gegeben, auf ihren Standardwert gesetzt.

## License
This project is licensed under the MIT License. See the LICENSE file for details.

### Gogs

Mandatory arguments are marked with bold and italic

| Argument | Description | Default Value |
|----------|--------------|:--------------:|
| ***DOMAINNAMES*** | List of domainnames seperated by a space | |
| **GOGS_APP_NAME** | Application name | Gogs: Go Git Service |
| GOGS_RUN_MODE | Possible values: prod, dev, test | prod |
| GOGS_REPOSITORY_ANSI_CHARSET | | iso-8859-1 |
| GOGS_REPOSITORY_FORCE_PRIVATE | | False |
| GOGS_REPOSITORY_MAX_CREATION_LIMIT | | -1 |
| GOGS_REPOSITORY_PULL_REQUEST_QUEUE_LENGTH | | 1000 |
| GOGS_REPOSITORY_MIRROR_QUEUE_LENGTH | | 1000 |
| GOGS_REPOSITORY_PREFERRED_LICENSES | | MIT License,Apache License 2.0 |
| GOGS_REPOSITORY_DISABLE_HTTP_GIT | | False |
| GOGS_REPOSITORY_EDITOR_LINE_WRAP_EXTENSIONS | | .txt,.md,.markdown,.mdown,.mkd, |
| GOGS_REPOSITORY_EDITOR_PREVIEWABLE_FILE_MODES | | markdown |
| GOGS_REPOSITORY_UPLOAD_ENABLE_UPLOAD | | True |
| GOGS_REPOSITORY_UPLOAD_ALLOWED_TYPES | | |
| GOGS_REPOSITORY_UPLOAD_FILE_MAX_SIZE | | 3 |
| GOGS_REPOSITORY_UPLOAD_MAX_FILES | | 5 |
| GOGS_UI_EXPLORE_PAGING_NUM | | 20 |
| GOGS_UI_ISSUE_PAGING_NUM | | 10 |
| GOGS_UI_FEED_MAX_COMMIT_NUM | | 5 |
| GOGS_UI_THEME_COLOR_META_TAG | | #ff5343 |
| GOGS_UI_MAX_DISPLAY_FILE_SIZE | | 8388608 |
| GOGS_UI_ADMIN_USER_PAGING_NUM | | 50 |
| GOGS_UI_ADMIN_REPO_PAGING_NUM | | 50 |
| GOGS_UI_ADMIN_NOTICE_PAGING_NUM | | 25 |
| GOGS_UI_ADMIN_ORG_PAGING_NUM | | 50 |
| GOGS_UI_USER_REPO_PAGING_NUM | | 15 |
| GOGS_MARKDOWN_ENABLE_HARD_LINE_BREAK | | False |
| GOGS_MARKDOWN_CUSTOM_URL_SCHEMES | | |
| **GOGS_SERVER_SSH_PORT** | Port number to be exposed in clone URL | 22 |
| GOGS_SERVER_MINIMUM_KEY_SIZE_CHECK | | True |
| GOGS_SERVER_OFFLINE_MODE | | False |
| GOGS_SERVER_DISABLE_ROUTER_LOG | | True |
| GOGS_SERVER_ENABLE_GZIP | | False |
| GOGS_SERVER_LANDING_PAGE | Possible values: home, explore | home |
| **GOGS_DATABASE_TYPE** | The database type to use. Possible values: sqlite3, mysql, postgres | sqlite3 |
| **GOGS_DATABASE_HOST** | Database host address (only mysql and postgres) | mysql |
| **GOGS_DATABASE_PORT** | Database port (only mysql and postgres) | 3306 |
| **GOGS_DATABASE_NAME** | Database name (only mysql and postgres) | gogs |
| **GOGS_DATABASE_USER** | Databse user (only mysql and postgres) | gogs |
| **GOGS_DATABASE_PASSWORD** | Database user password (only mysql and postgres) | |
| GOGS_DATABASE_PGSQL_SSL_MODE | Possible values: disable, require, verify-full | disable |
| GOGS_SECURITY_LOGIN_REMEMBER_DAYS | | 7 |
| GOGS_SECURITY_REVERSE_PROXY_AUTHENTICATION_USER | | X-WEBAUTH-USER |
| GOGS_SERVICE_ACTIVE_CODE_LIVE_MINUTES | | 180 |
| GOGS_SERVICE_RESET_PASSWD_CODE_LIVE_MINUTES | | 180 |
| GOGS_SERVICE_REGISTER_EMAIL_CONFIRM | | False |
| **GOGS_SERVICE_DISABLE_REGISTRATION** | Disable registration, after which only admin can create accounts for users | False |
| **GOGS_SERVICE_REQUIRE_SIGNIN_VIEW** | Enable this to force users to log in to view any page | False |
| GOGS_SERVICE_ENABLE_NOTIFY_MAIL | | False |
| GOGS_SERVICE_ENABLE_REVERSE_PROXY_AUTHENTICATION | | False |
| GOGS_SERVICE_ENABLE_REVERSE_PROXY_AUTO_REGISTRATION | | False |
| GOGS_SERVICE_ENABLE_CAPTCHA | | True |
| GOGS_WEBHOOK_QUEUE_LENGTH | | 1000 |
| GOGS_WEBHOOK_DELIVER_TIMEOUT | | 5 |
| GOGS_WEBHOOK_SKIP_TLS_VERIFY | | False |
| GOGS_WEBHOOK_PAGING_NUM | | 10 |
| **GOGS_MAILER_ENABLE** | Enable mail service | False |
| GOGS_MAILER_SEND_BUFFER_LEN | | 100 |
| GOGS_MAILER_SUBJECT | | %(APP_NAME)s |
| **GOGS_MAILER_HOST** | SMTP mail host address and port (example: smtp.gogs.io:587) | |
| GOGS_MAILER_SKIP_VERIFY | | False |
| **GOGS_MAILER_FROM** | Mail from address, RFC 5322. This can be just an email address, or the “Name” <email@example.com> format | |
| **GOGS_MAILER_USER** | SMTP user name | |
| **GOGS_MAILER_PASSWORD** | SMTP user password | |
| GOGS_MAILER_DISABLE_HELO | | False |
| GOGS_MAILER_HELO_HOSTNAME | | |
| GOGS_MAILER_ENABLE_HTML_ALTERNATIVE | | False |
| GOGS_CACHE_ADAPTER | Possible values: memory, redis, memcache | memory |
| GOGS_CACHE_INTERVAL | | 60 |
| GOGS_CACHE_HOST | | |
| GOGS_SESSION_PROVIDER | Possible values: memory, file, redis | memory |
| GOGS_SESSION_PROVIDER_CONFIG | | /var/lib/gogs/data/sessions |
| GOGS_SESSION_COOKIE_NAME | | gogs_session |
| GOGS_SESSION_COOKIE_SECURE | | True |
| GOGS_SESSION_ENABLE_SET_COOKIE | | True |
| GOGS_SESSION_GC_INTERVAL_TIME | | 86400 |
| GOGS_SESSION_SESSION_LIFE_TIME | | 86400 |
| GOGS_PICTURE_GRAVATAR_SOURCE | | gravatar |
| GOGS_PICTURE_DISABLE_GRAVATAR | | False |
| GOGS_PICTURE_ENABLE_FEDERATED_AVATAR | | False |
| GOGS_ATTACHMENT_ENABLE | | True |
| GOGS_ATTACHMENT_ALLOWED_TYPES | | image/jpeg\|image/png\|image/gif |
| GOGS_ATTACHMENT_MAX_SIZE | | 4 |
| GOGS_ATTACHMENT_MAX_FILES | | 5 |
| GOGS_LOG_MODE | Possible values: console, file, conn, smtp, database | console |
| GOGS_LOG_LEVEL | Possible values: Info, Trace, Debug, Warn, Error, Critical | Info |
| GOGS_LOG_FILES_LOG_ROTATE | | True |
| GOGS_LOG_FILES_MAX_LINES | | 1000000 |
| GOGS_LOG_FILES_MAX_SIZE_SHIFT | | 28 |
| GOGS_LOG_FILES_DAILY_ROTATE | | True |
| GOGS_LOG_FILES_MAX_DAYS | | 7 |
| GOGS_LOG_CONN_RECONNECT_ON_MSG | | False |
| GOGS_LOG_CONN_RECONNECT | | False |
| GOGS_LOG_CONN_PROTOCOL | | tcp |
| GOGS_LOG_CONN_ADDR | | |
| GOGS_LOG_SMTP_SUBJECT | | Diagnostic message from server |
| GOGS_LOG_SMTP_HOST | | |
| GOGS_LOG_SMTP_USER | | |
| GOGS_LOG_SMTP_PASSWD | | |
| GOGS_LOG_SMTP_RECEIVERS | | |
| GOGS_LOG_DATABASE_DRIVER | | |
| GOGS_LOG_DATABASE_CONN | | |
| GOGS_CRON_ENABLED | | True |
| GOGS_CRON_RUN_AT_START | | False |
| GOGS_CRON_UPDATE_MIRRORS_SCHEDULE | | @every 10m |
| GOGS_CRON_REPO_HEALTH_CHECK_SCHEDULE | | @every 24h |
| GOGS_CRON_REPO_HEALTH_CHECK_TIMEOUT | | 60s |
| GOGS_CRON_REPO_HEALTH_CHECK_ARGS | | 60s |
| GOGS_CRON_CHECK_REPO_STATS_RUN_AT_START | | True |
| GOGS_CRON_CHECK_REPO_STATS_SCHEDULE | | @every 24h |
| GOGS_GIT_DISABLE_DIFF_HIGHLIGHT | | False |
| GOGS_GIT_MAX_GIT_DIFF_LINES | | 10000 |
| GOGS_GIT_MAX_GIT_DIFF_LINE_CHARACTERS | | 500 |
| GOGS_GIT_MAX_GIT_DIFF_FILES | | 100 |
| GOGS_GIT_GC_ARGS | | |
| GOGS_GIT_TIMEOUT_MIGRATE | | 600 |
| GOGS_GIT_TIMEOUT_MIRROR | | 300 |
| GOGS_GIT_TIMEOUT_CLONE | | 300 |
| GOGS_GIT_TIMEOUT_PULL | | 300 |
| GOGS_GIT_TIMEOUT_GC | | 60 |
| GOGS_MIRROR_DEFAULT_INTERVAL | | 8 |
| GOGS_API_MAX_RESPONSE_ITEMS | | 50 |
| GOGS_OTHER_SHOW_FOOTER_BRANDING | | False |
| GOGS_OTHER_SHOW_FOOTER_VERSION | | True |
| GOGS_OTHER_SHOW_FOOTER_TEMPLATE_LOAD_TIME | | True |

### Nginx

| Argument                     | Description | Default Value |
|------------------------------|-------------|:-------------:|
| NGINX_CONN_LIMIT_PER_IP      |             |      10       |
| NGINX_REQ_LIMIT_PER_IP_RATE  |             |      15       |
| NGINX_REQ_LIMIT_PER_IP_BURST |             |      25       |
| NGINX_FASTCGI_READ_TIMEOUT   |             |      120      |
| NGINX_CLIENT_MAX_BODY_SIZE   |             |     256M      |
| NGINX_WORKER_PROCESSES       |             |       1       |
| NGINX_REWRITE_HTTPS               |             |     True      |
