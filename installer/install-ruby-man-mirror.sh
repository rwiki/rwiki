#!/bin/sh
# Rubyリファレンスマニュアルミラーを作るサンプルスクリプト
# sample script for making mirror of ruby reference manual
#
# copyright (c) 2003- Kazuhiro NISHIYAMA
# You can redistribute it and/or modify it under the same term as Ruby.

: ${EMAIL="$USER@$HOST"}
: ${ADDRESS="$EMAIL"}

: ${PREFIX="$HOME/ruby-man-mirror"}
: ${WEBDIR="$HOME/public_html/ruby-man"}
: ${BUILDDIR="$PREFIX/build-dir"}
: ${CHECKOUTDIR="$PREFIX/checkout-dir"}
if [ -d "$CHECKOUTDIR/app/rwiki" ]; then
  : ${APPRWIKIDIR="$CHECKOUTDIR/app/rwiki"}
else
  : ${APPRWIKIDIR="$(pwd)/.."}
fi

PATH="$PREFIX/bin":/usr/bin:/bin

set -e

case "$1" in
  cvs-checkout)
    mkdir -p "$CHECKOUTDIR" && cd "$CHECKOUTDIR"
    cvs -z3 -d :pserver:anonymous@cvs.ruby-lang.org:/src checkout ruby
    cvs -z3 -d :pserver:anonymous@cvs.ruby-lang.org:/src checkout app/rwiki
    exit 0
    ;;
  cvs-update)
    if [ ! -d "$CHECKOUTDIR/ruby" ]; then
      echo "$CHECKOUTDIR: not found" 1>&2
      exit 1
    fi
    cd "$APPRWIKIDIR" && cvs -q update
    cd "$CHECKOUTDIR/ruby" && cvs -q update
    exit 0
    ;;
  site-files)
    mkdir -p "$WEBDIR" && cd "$WEBDIR"
    if [ -f "$WEBDIR/style.css" ]; then
      echo "$WEBDIR/style.css: already exist"
    else
      wget -N -O "$WEBDIR/style.css" "http://www.ruby-lang.org/ja/man-1.6/style.css"
      ruby -pi -e 'gsub(/EEEEEE/, "CCCCCC")' "$WEBDIR/style.css"
    fi
    if [ -f "$WEBDIR/.htaccess" ]; then
      echo "$WEBDIR/.htaccess: already exist"
    else
      {
        echo "#<Files *.cgi>"
	echo "#  SetHandler cgi-script"
	echo "#</Files>"
        echo
        echo "<LimitExcept GET HEAD>" 
	echo "  deny from all"
        echo "</LimitExcept>" 
      } > "$WEBDIR/.htaccess"
    fi
    exit 0
    ;;
  rd-files)
    mkdir -p "$PREFIX" && cd "$PREFIX"
    if [ -d man-rd-ja ]; then
      echo man-rd-ja: already exist
    else
      set -e
      wget -N http://www.ruby-lang.org/ja/man/man-rd-ja.tar.gz
      tar zxvf man-rd-ja.tar.gz
      wget -N http://www.ruby-lang.org/ja/man/man-rd-ja-reject.tar.gz
      tar zxvf man-rd-ja-reject.tar.gz
      mv man-rd-ja-reject/*.rd man-rd-ja
      rmdir man-rd-ja-reject
    fi
    exit 0
    ;;
  ruby-install)
    if [ ! -f "$CHECKOUTDIR/ruby/configure" ]; then
      cd "$CHECKOUTDIR/ruby" && autoconf
    fi
    mkdir -p "$BUILDDIR/ruby" && cd "$BUILDDIR/ruby"
    "$CHECKOUTDIR/ruby/configure" --prefix="$PREFIX" --program-suffix=18
    make
    make test 
    make install
    exit 0
    ;;
  rwiki-install)
    cd "$APPRWIKIDIR"
    ruby18 install.rb -d "$PREFIX/lib"
    cd "$APPRWIKIDIR/installer"
    ruby18 rwiki-installer.rb \
      "--prefix=$PREFIX" \
      "--address=$ADDRESS" \
      "--mailto=mailto:$EMAIL" \
      "--rw-css=style.css" \
      "--rw-dbdir=../man-rd-ja" \
      "--rw-top-name=Rubyリファレンスマニュアル" \
      "--rw-title=Rubyリファレンスマニュアルミラー" \
      "--rw-drb-uri=druby://localhost:7429" \
      "--daemon-file=ruby-man-rwiki.rb" \
      "--webdir=$WEBDIR" \
      "--initd-file=run-ruby-man-rwiki.sh" \
      "--cgi-file=index.cgi" \
      install
    exit 0
    ;;
  clean)
    rm -r "$BUILDDIR"
    rm -r "$CHECKOUTDIR"
    exit 0
    ;;
  all)
    if [ -d "$CHECKOUTDIR/ruby" ]; then
      "$0" cvs-update
    else
      "$0" cvs-checkout
    fi
    "$0" site-files
    "$0" rd-files
    "$0" ruby-install
    "$0" rwiki-install
    exit 0
    ;;
  *)
    echo "Usage: $0 {cvs-checkout|cvs-update|site-files|rd-files|ruby-install|rwiki-install|all}"
    exit 1
    ;;
esac

