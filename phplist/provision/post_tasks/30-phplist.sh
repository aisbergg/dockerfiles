#!/bin/bash
set -e

templer --force \
    --dynamic-contextfiles \
    --defaults-type-check \
    -c  /provision/vars/30-phplist.yml \
    /data/www/admin/plugins/CKEditorPlugin/ckeditor/config.js \
    /data/www/admin/plugins/CKEditorPlugin/ckeditor/config.js

chmod o-rwx /data/www/config/config.php
