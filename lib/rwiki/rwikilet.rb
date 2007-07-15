# -*- indent-tabs-mode: nil -*-
require "rwiki/service"

module WEBrick
  class RWikilet < WEBrick::HTTPServlet::AbstractServlet
    def initialize(server, *options)
      @rwiki = options.shift
      @log_level = options.shift
      super(server, *options)
      @logger.debug("#{self.class}(initialize)")
    end

    def service(req, res)
      RWiki::Service.new(@rwiki, @log_level).serve(req, res)
    end
  end
end
