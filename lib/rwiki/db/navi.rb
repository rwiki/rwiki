# -*- indent-tabs-mode: nil -*-

require 'English'

require 'monitor'

module RWiki
  module DB
    class Navi
      include MonitorMixin

      attr_reader :count
      attr_accessor :updatable, :max, :border

      alias_method(:updatable?, :updatable)
      
      def initialize(page, default_max=1000, count={})
        super()
        @page = page
        @default_max = default_max
        @updatable = true
        self.count = count
      end

      def count=(new_count)
        synchronize do
          @count = {}
          new_count.each do |name, value|
            val = value
            @count[name] = val
          end
          reset_dirty
        end
      end
      
      def [](name, default=0)
        @count[name] || default
      end

      def update!(name)
        return unless updatable?
        synchronize do
          @count[name] ||= 0
          @count[name] += 1
          dirty!
          if too_dirty?
            normalize!
            @page.store(@count)
            reset_dirty
          end
        end
      end

      private
      def reset_dirty
        synchronize do
          @dirty = 0
        end
      end

      def dirty!
        synchronize do
          @dirty += 1
        end
      end

      def too_dirty?
        @dirty > 50
      end

      def too_high?(value)
        value > (@max || @default_max)
      end

      def normalize!
        counts = @count.collect{|name, value| value}.sort
        if too_high?(counts.last)
          synchronize do
            base = counts[(counts.size * (2.0 / 3.0)).to_i]
            @count.each_key do |key|
              @count[key] -= base
              @count[key] = 0 if @count[key] < 0
            end
          end
        end
      end

    end
  end
end
