#!/bin/bash
set -ex
umask 0007

apk --no-cache --no-progress --virtual .install-deps add rsync

tempdir="$(mktemp -d)"

# download sources
curl -fSL "https://sourceforge.net/projects/phplist/files/phplist/${PHPLIST_VERSION}/phplist-${PHPLIST_VERSION}.tgz/download" -o $tempdir/phplist.tgz
echo "$PHPLIST_SHA256_CHECKSUM  $tempdir/phplist.tgz" | sha256sum -c >/dev/null
curl -fSL "https://download.cksource.com/CKEditor/CKEditor/CKEditor%20${CKEDITOR_VERSION}/ckeditor_${CKEDITOR_VERSION}_standard.zip" -o $tempdir/ckeditor.zip
echo "$CKEDITOR_SHA256_CHECKSUM  $tempdir/ckeditor.zip" | sha256sum -c >/dev/null

# install phpList
tar xzf $tempdir/phplist.tgz -C "$tempdir"
rsync -rlD --exclude '*.htaccess' $tempdir/phplist-$PHPLIST_VERSION/public_html/lists/ /container/www/
mkdir -p /container/www/uploadimages
rm /container/www/config/*
# remove phplist.org rssfeeds (those slow down the page loading)
( cd /container/www/admin && patch -p0 < /install/no-newsfeed.patch >/dev/null )

# install CKEditor
unzip -qq -d /container/www/admin/plugins/CKEditorPlugin/ $tempdir/ckeditor.zip
cp -f /install/ckeditor-config.js /container/www/admin/plugins/CKEditorPlugin/ckeditor/config.js

# cleanup
rm -rf "$tempdir"
apk del .install-deps
