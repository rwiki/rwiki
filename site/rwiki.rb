#!/usr/local/bin/ruby

# rwiki.rb
#
# Copyright (c) 2000-2001 Masatoshi SEKI
#
# rwiki.rb is copyrighted free software by Masatoshi SEKI.
# You can redistribute it and/or modify it under the same term as Ruby.

ENV["LANG"] = "en"

require 'rw-config'
require 'rwiki/rwiki'
require 'rwiki/front'
require 'rwiki/info'
require 'rwiki/map'
require 'rwiki/orphan'
require 'rwiki/like'
#  require 'rwiki/rw-concat'
#  require 'rwiki/rw-arb'
#  require 'rwiki/shelf/shelf'
#  require 'rwiki/static_view'
#  require 'rwiki/storycard'
#  require 'rwiki/story-inline-test'

unless $DEBUG
  # Run as a daemon...
  exit!( 0 ) if fork
  Process.setsid
  exit!( 0 ) if fork
end

#  RWiki::StoryCard.install('rw-story', 'rw-0001', /^rw-\d+$/)

book = RWiki::Book.new

DRb.start_service(RWiki::DRB_URI, book.front)
puts DRb.uri

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

