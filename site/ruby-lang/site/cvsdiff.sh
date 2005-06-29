#!/bin/sh

: ${DB_DIR="/var/rwiki/rd"}
: ${X_URL="http://localhost/rwiki"}
: ${DIFF_FROM="-D1 hour ago"}
: ${DIFF_TO="-rHEAD"}
: ${SUBJECT="[RWiki-diff] `date '+%Y-%m-%d %H:%M %z'`"}
: ${MAIL_FROM="root"}
: ${MAIL_TO="root"}
: ${CONTENT_TYPE="text/plain; charset=iso-2022-jp"}
: ${BODY_FILTER="unescape_and_nkf_j"}
: ${MAIL_COMMAND="cat"}
: ${CONTENT_CHANGED_HOOK=":"}
: ${DIFF_FILTER="cat"}

PATH=/usr/bin:/bin
umask 022
cd "$DB_DIR"

TMPFILE=`mktemp -t cvsdiff.XXXXXX` || exit 1

cvs -fnq diff '-F^[=+:-]' -uN "$DIFF_FROM" "$DIFF_TO" | "$DIFF_FILTER" >> "$TMPFILE"

unescape_and_nkf_j () {
  ruby -rnkf -rcgi -pe '
    if /^\w/
      $_ = CGI.unescape($_)
    end
    $_ = NKF.nkf("-j", $_)
  '
}

if [ -s "$TMPFILE" ]; then
  {
    echo "From: $MAIL_FROM"
    echo "To: $MAIL_TO"
    echo "X-URL: $X_URL"
    echo "Subject: $SUBJECT"
    echo "Mime-Version: 1.0"
    echo "Content-Type: $CONTENT_TYPE"
    echo
    cat "$TMPFILE" | $BODY_FILTER
  } | $MAIL_COMMAND
  $CONTENT_CHANGED_HOOK "$TMPFILE"
fi

rm -f "$TMPFILE"
