# -*- indent-tabs-mode: nil -*-
require "rwiki/service"

module WEBrick
  class RWikilet < WEBrick::HTTPServlet::AbstractServlet
    def initialize(server, *options)
      @rwiki = options.shift
      super(server, *options)
    end

    def service(req, res)
      RWiki::Service.new(@rwiki).serve(req, res)
    end
  end
end
