#!/usr/local/bin/ruby

# rwiki.rb
#
# Copyright (c) 2000-2001 Masatoshi SEKI
#
# rwiki.rb is copyrighted free software by Masatoshi SEKI.
# You can redistribute it and/or modify it under the same term as Ruby.

$KCODE = 'EUC'

require 'rw-config'
require 'rwiki/rwiki'
require 'rwiki/rw-info'
require 'rwiki/rw-map'
require 'rwiki/rw-orphan'
require 'rwiki/rw-like'
require 'rwiki/rw-concat'
#  require 'rwiki/rw-arb'
require 'rwiki/weakpage'
require 'rwiki/bts'
require 'rwiki/storycard'
require 'rwiki/rss-writer'

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
  exit
else
  STDIN.reopen('/dev/null')
  STDOUT.reopen('/dev/null', 'w')
  STDERR.reopen('/dev/null', 'w')
  DRb.thread.join
end

