#!/usr/local/bin/ruby

$KCODE = 'EUC'  # SETUP
rwiki_uri = 'druby://localhost:8470' # SETUP
rwiki_log_dir = '/var/tmp'  # SETUP
use_as_cgi_stub = true  # SETUP

module RWiki
  module SOAP
    class Servant
      ALLOW_GET_PAGE = false  # SETUP
    end
  end
end

require 'rwiki/soap/servant'

if use_as_cgi_stub
  # cgistub
  require 'soap/rpc/cgistub'
  server = SOAP::RPC::CGIStub.new('CGIStub', RWiki::SOAP::NS)
else
  # standalone server
  require 'soap/rpc/standaloneServer'
  server = SOAP::RPC::StandaloneServer.new('Standalone', RWiki::SOAP::NS,
                                           'localhost', 8080)
end

server.set_log(File.join(rwiki_log_dir, 'RWikiSOAPServer.log')) if rwiki_log_dir

DRb.start_service()
rwiki = DRbObject.new(nil, rwiki_uri)
server.add_servant(RWiki::SOAP::Servant.new(rwiki))
server.start
