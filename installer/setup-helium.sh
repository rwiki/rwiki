#!/bin/sh
# heliumの/var/lib/ruby-manの更新用スクリプト
# usage: sh ./setup-helium.sh install

RUBY=ruby18
PREFIX=/var/lib/ruby-man

set -ex

(cd .. && $RUBY install.rb -d $PREFIX/lib)

NAME=ruby-man
$RUBY rwiki-installer.rb \
  "--prefix=$PREFIX" \
  "--address=rubyist ML" \
  "--mailto=mailto:rubyist@freeml.com" \
  "--rw-css=style.css" \
  "--rw-dbdir=../man-rd-ja" \
  "--rw-top-name=Rubyリファレンスマニュアル" \
  "--rw-title=Rubyリファレンスマニュアル" \
  "--rw-drb-uri=druby://localhost:7429" \
  "--daemon-file=$NAME-rwiki.rb" \
  "--webdir=$PREFIX/web" \
  "--rw-config-file=$NAME-config.rb" \
  "--initd-file=run-$NAME-rwiki.sh" \
  "--cgi-file=$NAME.cgi" \
  "$@"

NAME=install-guide-ja
$RUBY rwiki-installer.rb \
  "--prefix=$PREFIX" \
  "--address=webmaster" \
  "--mailto=mailto:webmaster@ruby-lang.org" \
  "--rw-css=install.css" \
  "--rw-dbdir=../rd-install-ja" \
  "--rw-top-name=top" \
  "--rw-title=Ruby インストールガイド" \
  "--rw-drb-uri=druby://localhost:8725" \
  "--daemon-file=$NAME-rwiki.rb" \
  "--webdir=$PREFIX/web" \
  "--rw-config-file=$NAME-config.rb" \
  "--initd-file=run-$NAME-rwiki.sh" \
  "--cgi-file=$NAME.cgi" \
  "$@"

NAME=install-guide-en
$RUBY rwiki-installer.rb \
  "--prefix=$PREFIX" \
  "--address=webmaster" \
  "--mailto=mailto:webmaster@ruby-lang.org" \
  "--rw-css=install.css" \
  "--rw-dbdir=../rd-install-en" \
  "--rw-top-name=top" \
  "--rw-title=Ruby Install Guide" \
  "--rw-drb-uri=druby://localhost:8726" \
  "--daemon-file=$NAME-rwiki.rb" \
  "--webdir=$PREFIX/web" \
  "--rw-config-file=$NAME-config.rb" \
  "--initd-file=run-$NAME-rwiki.sh" \
  "--cgi-file=$NAME.cgi" \
  "$@"

cat >$PREFIX/site/ext/00rwikiex.rb <<RUBY
\$LOAD_PATH.push '$PREFIX/rwikiex'
\$LOAD_PATH.uniq!

require 'rwiki/db/cvs'
RWiki::BookConfig.default.db = RWiki::DB::CVS.new(RWiki::DB_DIR)
RUBY

cat >$PREFIX/site/ext/common.rb <<RUBY
require 'rwiki/rss/writer'
require 'rwiki/weakpage'
require 'rwiki/history'

if \$0 == "./ruby-man-rwiki.rb"
  require 'rwiki/rw-method'
end
RUBY
