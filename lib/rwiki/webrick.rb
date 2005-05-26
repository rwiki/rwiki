require 'webrick'

module RWiki
  module WEBrickSupport
    def initialize(server, *options)
      @service = options.shift
      super(server, *options)
      @logger.debug("#{self.class}(initialize)")
    end

    def service(req, res)
      @service.serve(req, res)
    end
  end
end
