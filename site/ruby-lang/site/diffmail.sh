#!/bin/sh

: ${DB_DIR="/var/lib/ruby-man/man-rd-ja"}
export DB_DIR

: ${X_URL="http://www.ruby-lang.org/ja/man/"}
export X_URL

#: ${DIFF_FROM="-Dyesterday"} ${DIFF_TO="-rHEAD"}
: ${DIFF_FROM="-D61 minutes ago"} ${DIFF_TO="-rHEAD"}
export DIFF_FROM
export DIFF_TO

: ${MAIL_FROM="zn@mbf.nifty.com"}
: ${MAIL_TO="mandiff@ruby.quickml.com"}
export MAIL_FROM
export MAIL_TO

#: ${MAIL_COMMAND="/usr/sbin/sendmail -f $MAIL_FROM $MAIL_TO"}
: ${MAIL_COMMAND="/usr/sbin/sendmail -f kazu@ruby-lang.org $MAIL_TO"}
export MAIL_COMMAND

: ${CONTENT_CHANGED_HOOK="make_tarball"}
make_tarball () {
  VAR_TMPDIR="/var/tmp/kazu"
  if [ ! -d "$VAR_TMPDIR" ]; then
    mkdir "$VAR_TMPDIR"
  fi
  if [ ! -O "$VAR_TMPDIR" ]; then
    echo "$VAR_TMPDIR is not mine!"
    return 1
  fi
  cd "$VAR_TMPDIR"
  cvs -fQd $(cat $DB_DIR/CVS/Root) export -r HEAD man-rd-ja
  mkdir man-rd-ja-reject
  for f in man-rd-ja/*.rd; do
    ruby -e '
      ARGV.each do |fn|
        if /^### reject$/ === File.open(fn){|f| f.gets }
          File.rename(fn, File.join("man-rd-ja-reject", File.basename(fn)))
        end
      end
    ' "$f"
  done
  tar --owner=root --group=root -zcf man-rd-ja.tar.gz man-rd-ja
  tar --owner=root --group=root -zcf man-rd-ja-reject.tar.gz man-rd-ja-reject
  rm -r man-rd-ja man-rd-ja-reject
  mv man-rd-ja.tar.gz /var/www/www.ruby-lang.org/ja/man/
  mv man-rd-ja-reject.tar.gz /var/www/www.ruby-lang.org/ja/man/
}

: ${DIFF_FILTER="filterdiff_x_navi"}
filterdiff_x_navi () {
  filterdiff | filterdiff -x navi.rd
}

SUBJECT="[/ja/man/] `date '+%Y-%m-%d %H:%M %z'`"
. /var/lib/ruby-man/site/cvsdiff.sh

# install-guide-ja
SUBJECT="[/ja/install.cgi] `date '+%Y-%m-%d %H:%M %z'`"
DB_DIR="/var/lib/ruby-man/rd-install-ja"
X_URL="http://www.ruby-lang.org/ja/install.cgi"
CONTENT_CHANGED_HOOK=":"
. /var/lib/ruby-man/site/cvsdiff.sh

# install-guide-en
SUBJECT="[/en/install.cgi] `date '+%Y-%m-%d %H:%M %z'`"
DB_DIR="/var/lib/ruby-man/rd-install-en"
X_URL="http://www.ruby-lang.org/en/install.cgi"
CONTENT_CHANGED_HOOK=":"
. /var/lib/ruby-man/site/cvsdiff.sh
