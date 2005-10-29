#!/bin/sh
set -ex
test -d /var/lib/ruby-man
test -w /var/lib/ruby-man
test -x /var/lib/ruby-man
test -O /var/lib/ruby-man
cd $(dirname $0)
rm -vrf /var/lib/ruby-man/site
mkdir /var/lib/ruby-man/site
cp -v site/*.* /var/lib/ruby-man/site
rm -vrf /var/lib/ruby-man/web
mkdir /var/lib/ruby-man/web
cp -v web/*.* /var/lib/ruby-man/web
cd $(dirname $0)/../..
rm -rf /var/lib/ruby-man/lib/rt
rm -rf /var/lib/ruby-man/lib/rwiki
ruby -v install.rb -d /var/lib/ruby-man/lib --datadir /var/lib/ruby-man/data
