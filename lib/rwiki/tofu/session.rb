# -*- indent-tabs-mode: nil -*-

require "tofu/tofu"

require "rwiki/tofu/service"

module RWiki
  module Tofu
    class Session < ::Tofu::Session
      @@service = Service

      class << self
        def service=(service)
          @@service = service
        end
      end
      
      def initialize(rwiki, bartender, hint=nil)
        super(bartender, hint)
        @service = @@service.new(rwiki)
      end

      def service(context)
        @service.start(context)
      end
    end

    SessionFactory = Object.new

    class << SessionFactory
      attr_accessor :session, :rwiki_uri
      
      def new(bartender, hint=nil)
        rwiki = DRbObject.new_with_uri(rwiki_uri)
        session.new(rwiki, bartender, hint)
      end

      def to_s
        "RWiki::Tofu::SessionFactory"
      end
    end

    SessionFactory.session = Session
  end
end
