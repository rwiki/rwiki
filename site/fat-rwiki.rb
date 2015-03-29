#!/usr/local/bin/ruby

# rwiki.rb
#
# Copyright (c) 2000-2001 Masatoshi SEKI
#
# rwiki.rb is copyrighted free software by Masatoshi SEKI.
# You can redistribute it and/or modify it under the same term as Ruby.

$KCODE = 'EUC'

#ENV["LANG"] = "ja_JP.eucJP"
ENV["LANG"] = "en"

require 'rw-config'
require 'rwiki/rwiki'
require 'rwiki/orphan'
require 'rwiki/like'
require 'rwiki/concat'
#  require 'rwiki/arb'
require 'rwiki/bts'
require 'rwiki/storycard'
require 'rwiki/rss/writer'

unless $DEBUG
  # Run as a daemon...
  exit!( 0 ) if fork
  Process.setsid
  exit!( 0 ) if fork
end

RWiki::BTS.install('ToDo', 'ToDo001', /^ToDo\d+$/)
RWiki::StoryCard.install('RWiki2', 'RW001', /^RW\d+$/)

book = RWiki::Book.new

DRb.start_service(RWiki::DRB_URI, book.front)

if $DEBUG
  while gets
    RWiki.reload_rhtml
  end
  book.close
else
  STDIN.reopen('/dev/null')
  STDOUT.reopen('/dev/null', 'w')
  STDERR.reopen('/dev/null', 'w')
  trap("TERM") { book.close; exit }
  DRb.thread.join
end

