#!/usr/local/bin/ruby 

require 'drb/drb'

rwiki_uri = 'druby://localhost:8470'		# SETUP

DRb.start_service('druby://localhost:0')
rwiki = DRbObject.new_with_uri(rwiki_uri)
begin
  rwiki.cgi_start(ENV.to_hash, $stdin, $stdout)
rescue
  puts "content-type: text/plain;"
  puts
  puts "RWiki server seems to be down..."
end

