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
ENV["OUTPUT_CHARSET"] = "eucJP"

require 'rw-config'

$LOAD_PATH.unshift("/usr/local/share/rwiki/lib")

require 'rwiki/rwiki'
require 'rwiki/uptime'
require 'rwiki/info'
require 'rwiki/map'
require 'rwiki/orphan'
require 'rwiki/like'
require 'rwiki/concat'
#  require 'rwiki/arb'
require 'rwiki/rss/writer'
require 'rwiki/history'
require 'rwiki/rd/ext/entity'
require 'rwiki/rd/ext/enscript'

require 'rwiki/db/cvs'
RWiki::BookConfig.default.db = RWiki::DB::CVS.new(RWiki::DB_DIR)

require 'rwiki/storycard'
require 'rwiki/story-inline-test'
RWiki::StoryCard.install('RWiki2-story', 'RW-0001', /^RW-\d+$/)

require 'rwiki/shelf/shelf'
require 'rwiki/shelf/refer'
RWiki::Shelf.install(true)

require 'rwiki/slide'

book = RWiki::Book.new

DRb.start_service(RWiki::DRB_URI, book.front)

if $DEBUG
  while gets
    RWiki.reload_rhtml
  end
  book.close
else
  trap("HUP") { RWiki.reload_rhtml }
  trap("TERM") { book.close; exit }
  DRb.thread.join
end

