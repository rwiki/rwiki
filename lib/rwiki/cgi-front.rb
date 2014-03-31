require 'rwiki/service'
require 'rwiki/cgi'
require 'rwiki/rw-lib'

module RWiki
  class CGIFront
    def initialize(front)
      @front = front
    end

    def start(env, sin, sout)
      service = RWiki::Service.new(@front)
      cgi = RWiki::CGI.new({}, service)
      cgi.start(env, sin, sout)
    end
  end
end
                       
                       
