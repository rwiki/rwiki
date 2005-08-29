#!/bin/bash
set -ex

# config
WORKDIR="$(dirname $0)"
ARCHIVEDIR=/var/www/www.ruby-lang.org/ja/man/archive/
FTPDOCDIR=/home/ftp/pub/ruby/doc/

HTMLDIR=ruby-man-ja-html-$(date +'%Y%m%d')
RDDIR=ruby-man-ja-rd-$(date +'%Y%m%d')

RWIKIURI='druby://localhost:7429'
TOPPAGENAME=$'Ruby\245\352\245\325\245\241\245\354\245\363\245\271\245\336\245\313\245\345\245\242\245\353'

# needs trailing slash (for rsync)
RDSRCDIR=/var/lib/ruby-man/man-rd-ja/

TAR_COMMAND='tar --owner=root --group=root'
P7ZIP_COMMAND='/home/kazu/p7zip_4.20/bin/7za -tzip'


fetching () {
  cd "$WORKDIR"

  rsync -avzC "$RDSRCDIR" "$RDDIR"
  mkdir "$HTMLDIR"
  ../../interface/fetch_static_html.rb "$RWIKIURI" "$TOPPAGENAME" "$HTMLDIR"
  cp www/ja/man/style.css "$HTMLDIR"
}

packing () {
  cd "$WORKDIR"

  for CONTENTDIR in "$HTMLDIR" "$RDDIR"; do
    $TAR_COMMAND -jcvf "$CONTENTDIR".tar.bz2 "$CONTENTDIR"
    $TAR_COMMAND -zcvf "$CONTENTDIR".tar.gz "$CONTENTDIR"
    $P7ZIP_COMMAND a "$CONTENTDIR".zip "$CONTENTDIR"
  done
}

publishing_to_http () {
  cp -v "$HTMLDIR".* "$RDDIR".* "$ARCHIVEDIR"
  cd "$ARCHIVEDIR"
  md5sum ruby* > MD5SUM.txt
}

publishing_to_ftp () {
  cp -v "$HTMLDIR".* "$RDDIR".* "$FTPDOCDIR"
  cd "$FTPDOCDIR"
  md5sum ruby* > MD5SUM.txt
}

default_main () {
  fetching
  packing
  publishing_to_http
  publishing_to_ftp
}

default_main
