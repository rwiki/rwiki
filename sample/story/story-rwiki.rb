#!/usr/local/bin/ruby
# story-rwiki.rb
#
# Copyright (c) 2002 Masatoshi SEKI
#
# rwiki.rb is copyrighted free software by Masatoshi SEKI.
# You can redistribute it and/or modify it under the same term as Ruby.

$KCODE = 'EUC'

require 'story-config'
require 'rwiki/rwiki'
require 'rwiki/rw-concat'
require 'rwiki/rw-info'
require 'rwiki/rw-map'
#  require 'rwiki/rw-orphan'
#  require 'rwiki/rw-like'
#  require 'rwiki/rw-concat'
#  require 'rwiki/rw-arb'

require 'rwiki/storycard'

unless $DEBUG
  # Run as a daemon...
  exit!( 0 ) if fork
  Process.setsid
  exit!( 0 ) if fork
end

RWiki::StoryCard.install('RWiki2', 'RW-001', /^RW-\d+$/)
RWiki::StoryCard.install('ERB2', 'ERB-001', /^ERB-\d+$/)

book = RWiki::Book.new

DRb.start_service(RWiki::DRB_URI, book.front)

if $DEBUG
  while gets
    RWiki::reload_rhtml
  end
  exit
else
  STDIN.reopen('/dev/null')
  STDOUT.reopen('/dev/null', 'w')
  STDERR.reopen('/dev/null', 'w')
  DRb.thread.join
end

