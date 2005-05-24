# -*- indent-tabs-mode: nil -*-

require "tofu/tofu"

require "rwiki/tofu/service"

module RWiki
  module Tofu
    class Session < ::Tofu::Session
      def initialize(bartender, hint=nil)
        super
        @service = nil
      end
      
      def service(context)
        setup_service(context)
        @service.start(context)
      end

      private
      def setup_service(context)
        if @service.nil?
          rwiki_uri, service_factory, = context.options
          rwiki = DRbObject.new_with_uri(rwiki_uri)
          service_factory ||= Service
          @service = service_factory.new(rwiki)
        end
      end
    end
  end
end
