#!/bin/bash
/usr/bin/build_site.sh >/dev/null 2>&1
exec /usr/sbin/cron -f
