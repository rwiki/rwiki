#!/usr/local/bin/ruby1.8.1 -Ke

# install by:
# /usr/local/bin/ruby1.8.1 rwiki-installer.rb '--prefix=/var/lib/ruby-man' '--address=webmaster' '--mailto=mailto:webmaster@ruby-lang.org' '--rw-css=install.css' '--rw-dbdir=../rd-install-ja' '--rw-top-name=top' '--rw-title=Ruby インストールガイド' '--rw-drb-uri=druby://localhost:8725' '--daemon-file=install-guide-ja-rwiki.rb' '--webdir=/var/lib/ruby-man/web' '--rw-config-file=install-guide-ja-config.rb' '--initd-file=run-install-guide-ja-rwiki.sh' '--cgi-file=install-guide-ja.cgi'

$LOAD_PATH.unshift "/var/lib/ruby-man/lib"

require 'install-guide-ja-config'
require 'rwiki/rwiki'
require 'rwiki/info'
require 'rwiki/map'
require 'rwiki/orphan'
require 'rwiki/like'
#  require 'rwiki/concat'
#  require 'rwiki/arb'

require 'getopts'
getopts('dv', 'fg', 'noreopen')
$DEBUG = $OPT_d if $OPT_d
$VERBOSE = $OPT_v if $OPT_v
$OPT_fg ||= $DEBUG

def reload_ext_rbfiles
  Dir['./ext/*.rb'].sort.each do |rbfile|
    load rbfile
  end
end
reload_ext_rbfiles

unless $OPT_fg
  # Run as a daemon...
  exit!( 0 ) if fork
  Process.setsid
  exit!( 0 ) if fork
end

book = RWiki::Book.new
DRb.start_service(RWiki::DRB_URI, book.front)

unless $OPT_fg
  pidfile = "/var/lib/ruby-man/site/rwiki.pid"
  File.open(pidfile, 'w'){|f| f.puts Process.pid }
  at_exit { File.unlink(pidfile) }
end

trap("HUP") { RWiki.reload_rhtml; reload_ext_rbfiles }
trap("TERM") { exit }

if $DEBUG
  while gets
    RWiki.reload_rhtml
    reload_ext_rbfiles
  end
  exit
else
  unless $OPT_noreopen
    STDIN.reopen('/dev/null')
    STDOUT.reopen('/dev/null', 'w')
    STDERR.reopen('/dev/null', 'w')
  end
  DRb.thread.join
end
