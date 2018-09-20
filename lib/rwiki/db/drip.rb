require 'rwiki/db/base'

module RWiki
  module DB
    class Drip < Base
      def initialize(drip)
        @drip = drip
        super()
      end

      private
      def drip_get(key, rev=nil)
        if rev
          value, tag = @drip[rev.to_i(36)]
          unless key == tag
            return nil, nil
          end
        else
          mod, value, = @drip.head(1, key).first
        end
        return nil, nil if value.empty?
        return mod, value
      end

      def drip_set(key, value)
        @drip.write(value, key)
      end

      def set(key, value, opt=nil)
        return if value.nil?
        drip_set(key, value)
        nil
      end

      def get(key, rev=nil)
        mod, value = drip_get(key, rev)
        value
      rescue
        nil
      end

      public
      def modified(key)
        mod, value = drip_get(key)
        @drip.key_to_time(mod)
      rescue
        nil
      end

      def revision(key)
        mod, = drip_get(key)
        mod.to_s(36)
      rescue
        ''
      end

      def each
        cur = ''
        while cur = @drip.tag_next(cur)
          yield(cur)
        end
      end
    end
  end
end
