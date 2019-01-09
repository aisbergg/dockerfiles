#!/bin/bash
set -e

templer --force \
    --dynamic-contextfiles \
    --defaults-type-check \
    -c  /provision/vars/30-phplist.yml \
    /container/www/admin/plugins/CKEditorPlugin/ckeditor/config.js \
    /container/www/admin/plugins/CKEditorPlugin/ckeditor/config.js

chmod o-rwx /container/www/config/config.php || true
