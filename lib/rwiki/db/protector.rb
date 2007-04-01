module RWiki
  module DB
    module Protector
      class ProtectionError < StandardError
      end

      chars = ('a'..'z').to_a + ('A'..'Z').to_a + ("0".."9").to_a
      KEY_SIZE = 6
      KEY = ""
      KEY_SIZE.times do
        KEY << chars[rand(chars.size)]
      end

      def protect_key_supported?
        true
      end

      def protect_key
        KEY
      end

      private
      def set(key, value, opt=nil)
        options = opt || {}
        protect_key = nil
        protect_key = options[:query]["protect_key"] if options[:query]
        if protect_key.nil?
          raise ProtectionError, _("protect key isn't presented")
        end
        if protect_key != KEY
          raise ProtectionError, _("protect key doesn't match")
        end
        super(key, value, opt)
      end
    end
  end
end
