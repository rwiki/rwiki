require 'forwardable'
require 'socket'
require 'uri'
require 'drb/drb'

require 'rwiki/soap/common'

module RWiki
  module SOAP
    class Servant
      extend Forwardable

      def_delegators(:@rwiki, :find, :src, :modified)
      def_delegators(:@rwiki, :recent_changes)

      if ALLOW_GET_PAGE
        def_delegators(:@rwiki, :page)
      end

      def initialize(rwiki)
        @rwiki = rwiki

        uri = URI.parse(@rwiki.__drburi)
        @drb_host = uri.host
        @drb_port = uri.port

        if @drb_host.empty?
          @drb_host = Socket.gethostbyname(Socket.gethostname)[0]
        else
          @drb_host = Socket.gethostbyname(@drb_host)[0]
        end
      end

      def allow_get_page # XML element name cann't include '?'.
        ALLOW_GET_PAGE ? true : false
      end

      def include(name) # XML element name cann't include '?'.
        @rwiki.include?(name)
      end

      def revision(name)
        page = @rwiki.page(name)
        page.revision
      end

      def copy(name, src, rev, log_message)
        page = @rwiki.page(name)
        set_src(page, src, rev, log_message)
        name
      end

      def append(name, src, rev, log_message)
        page = @rwiki.page(name)
        set_src(page, page.src.to_s + src, rev, log_message)
        name
      end

      def submit(name, src, rev, log_message)
        page = @rwiki.page(name)
        set_src(page, src, rev, log_message)
        name
      end

      def drb_host_and_port
        [@drb_host, @drb_port]
      end

      private
      def set_src(page, src, rev, log_message)
        props = {"commit_log" => log_message}
        page.set_src(src, rev) do |key|
          props[key]
        end
      end
    end
  end
end
