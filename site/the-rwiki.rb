#!/usr/local/bin/ruby

# the-rwiki.rb
#
# Copyright (c) 2000-2001 Masatoshi SEKI
#
# the-rwiki.rb is copyrighted free software by Masatoshi SEKI.
# You can redistribute it and/or modify it under the same term as Ruby.

$KCODE = 'EUC'

#ENV["LANG"] = "ja_JP.eucJP"
ENV["LANG"] = "en"

require 'rw-config'

$LOAD_PATH.unshift("/usr/local/share/rwiki/lib")

require 'rwiki/rwiki'
require 'rwiki/info'
require 'rwiki/map'
require 'rwiki/orphan'
require 'rwiki/like'
require 'rwiki/concat'
#  require 'rwiki/arb'
require 'rwiki/rss-writer'
require 'rwiki/history'
require 'rwiki/rd/ext/entity'

require 'rwiki/db/cvs'
RWiki::BookConfig.default.db = RWiki::DB::CVS.new(RWiki::DB_DIR)

require 'rwiki/shelf/shelf'
require 'rwiki/shelf/refer'
RWiki::Shelf.install(true)

require 'rwiki/shelf/slide'

book = RWiki::Book.new

DRb.start_service(RWiki::DRB_URI, book.front)

if $DEBUG
  while gets
    RWiki.reload_rhtml
  end
  exit
else
  trap("HUP") { RWiki.reload_rhtml }
  trap("TERM") { exit }
  DRb.thread.join
end

