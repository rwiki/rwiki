$KCODE = 'EUC'

module RWiki
  # RWiki Server setup
  ## Page 
  ADDRESS = 'Masatoshi SEKI'
  MAILTO = 'mailto:m_seki@mva.biglobe.ne.jp'
  CSS = nil
  LANG = nil
  CHARSET = nil
  
  ## Service
  DB_DIR = 'rd'
  TOP_NAME = 'top'
  TITLE = 'RWiki'
  DRB_URI = 'druby://:8470'
end

require 'rwiki/rwiki'
require 'rwiki/rw-concat'
require 'rwiki/rw-info'
require 'rwiki/rw-map'

require 'rwiki/slide'

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
    RWiki::reload_rhtml
  end
  exit
else
  STDIN.reopen('/dev/null')
  STDOUT.reopen('/dev/null', 'w')
  STDERR.reopen('/dev/null', 'w')
  DRb.thread.join
end

