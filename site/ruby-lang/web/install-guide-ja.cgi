#!/usr/local/bin/ruby1.8.1 -Ke

$LOAD_PATH.unshift "/var/lib/ruby-man/lib"

require 'rwiki/cgiapp'

module RWiki
  PASSPHRASE = "matumoto"
end

rwiki_uri = "druby://localhost:8725"
rwiki_log_dir = "/var/lib/ruby-man/log-install-ja"

DRb.start_service("druby://localhost:0")
rwiki = DRbObject.new( nil, rwiki_uri )
app = RWikiCGIApp.new( rwiki, rwiki_log_dir ).start()
