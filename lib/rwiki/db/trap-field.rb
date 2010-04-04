module RWiki
  module DB
    module TrapField
      class TrapFieldError < StandardError
      end

      def trap_field_supported?
        true
      end

      private
      def set(key, value, opt=nil)
        options = opt || {}
        query = options[:query] || {}
        trap_mail = query["trap-mail"] || ''
        trap_password = query["trap-password"] || ''
        if trap_mail.empty? and trap_password.empty?
          super(key, value, opt)
        else
          raise TrapFieldError, _("trap field(s) is filled.")
        end
      end
    end
  end
end
