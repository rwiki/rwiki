#!/usr/local/bin/ruby1.8.1 -Ke

$LOAD_PATH.unshift "/var/lib/ruby-man/lib"

require 'rwiki/cgiapp'

rwiki_uri = "druby://localhost:7429"
rwiki_log_dir = "/var/lib/ruby-man/log"

DRb.start_service("druby://localhost:0")
rwiki = DRbObject.new( nil, rwiki_uri )
app = RWikiCGIApp.new( rwiki, rwiki_log_dir )
app.level = Logger::Severity::ERROR
def app.prologue
  # do not set log level
end
app.start()
