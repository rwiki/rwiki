#!/usr/local/bin/ruby

require "webrick"

require 'drb/drb'
require 'tofu/tofulet'

require 'rwiki/tofu/session'

$KCODE = 'EUC'	# SETUP
rwiki_uri = 'druby://localhost:8470'	# SETUP
webrick_port = 1818	# SETUP


DRb.start_service()

logger = WEBrick::Log::new(STDERR, WEBrick::Log::INFO)

server = WEBrick::HTTPServer.new(:Port => webrick_port,
                                 :AddressFamily => Socket::AF_INET,
                                 :Logger => logger)

RWiki::Tofu::SessionFactory.rwiki_uri = rwiki_uri

bartender = Tofu::Bartender.new(RWiki::Tofu::SessionFactory)

server.mount("/", WEBrick::Tofulet, bartender)

trap("INT") {server.shutdown}
server.start
