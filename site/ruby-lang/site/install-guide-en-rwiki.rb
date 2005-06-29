#!/usr/bin/ruby1.8 -Ke

ENV["LANG"] = "C"
ENV["OUTPUT_CHARSET"] = "eucJP"

$LOAD_PATH.unshift "/var/lib/ruby-man/lib"

require 'install-guide-en-config'
require 'rwiki/rwiki'
require 'rwiki/front'
require 'rwiki/info'
require 'rwiki/map'
require 'rwiki/orphan'
require 'rwiki/like'
require 'rwiki/rss/writer'
require 'rwiki/history'
require 'rwiki/static_view'

require 'rwiki/db/cvs'
RWiki::BookConfig.default.db = RWiki::DB::CVS.new(RWiki::DB_DIR)

unless $DEBUG
  # Run as a daemon...
  exit!( 0 ) if fork
  Process.setsid
  exit!( 0 ) if fork
end

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
