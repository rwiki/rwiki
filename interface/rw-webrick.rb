#!/usr/local/bin/ruby

require "webrick"
require 'drb/drb'
require 'rwiki/rwikilet'

$KCODE = 'EUC'	# SETUP
rwiki_uri = 'druby://localhost:8470'	# SETUP
webrick_port = 1818	# SETUP


DRb.start_service()

logger = WEBrick::Log::new(STDERR, WEBrick::Log::INFO)

server = WEBrick::HTTPServer.new(:Port => webrick_port,
                                 :AddressFamily => Socket::AF_INET,
                                 :Logger => logger)

log_level = Logger::Severity::INFO
rwiki = DRbObject.new_with_uri(rwiki_uri)
server.mount("/", WEBrick::RWikilet, rwiki, log_level)

trap("INT") {server.shutdown}
server.start
