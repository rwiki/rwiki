#!/usr/local/bin/ruby1.8.1 -Ke

$LOAD_PATH.unshift "/var/lib/ruby-man/lib"

require 'rwiki/cgiapp'

rwiki_uri = "druby://localhost:8726"
rwiki_log_dir = "/var/lib/ruby-man/log-install-en"

DRb.start_service("druby://localhost:0")
rwiki = DRbObject.new( nil, rwiki_uri )
app = RWikiCGIApp.new( rwiki, rwiki_log_dir ).start()
