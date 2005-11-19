#!/usr/bin/ruby1.8 -Ku

ENV["LANG"] = "C"
ENV["OUTPUT_CHARSET"] = "utf-8"
ENV["GETTEXT_PATH"] = "/var/lib/ruby-man/data/locale"

$LOAD_PATH.unshift "/var/lib/ruby-man/lib"

require 'ruby-man-config-utf8'
require 'rwiki/rwiki'
require 'rwiki/transitional/front'
require 'rwiki/info'
require 'rwiki/map'
require 'rwiki/orphan'
require 'rwiki/like'
require 'rwiki/rss/writer'
require 'rwiki/history'
require 'rwiki/static_view'
require 'rwiki/uptime'

require 'rwiki/method'

require 'rwiki/db/cvs'
RWiki::BookConfig.default.db = RWiki::DB::CVS.new(RWiki::DB_DIR)

unless $DEBUG
  # Run as a daemon...
  exit!( 0 ) if fork
  Process.setsid
  exit!( 0 ) if fork
end

book = RWiki::Book.new
#DRb.start_service(RWiki::DRB_URI, RWiki::Transitional::Front.new(book, 'utf-8', 'euc-jp-ms'))
DRb.start_service(RWiki::DRB_URI, RWiki::Transitional::Front.new(book, 'utf-8', 'euc-jp'))

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
