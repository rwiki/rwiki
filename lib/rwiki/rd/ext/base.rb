# -*- indent-tabs-mode: nil -*-
require 'English'
require 'erb'

module RD
  module Ext
    class Base
      include ERB::Util
      extend ERB::Util

      class << self
        def inherited(klass)
          klass.const_set("EXTENSIONS", [])
        end

        def add_extension(name)
          extensions.push(name)
        end

        def extensions
          self::EXTENSIONS
        end

        def method_added(name)
          if /^ext_/ =~ name.to_s
            add_extension(name.to_s)
          end
        end

        def document(name)
          if respond_to?("about_#{name}")
            __send__("about_#{name}")
          else
            "(not documented)"
          end
        end
      end

      def apply(label, content, visitor)
        result = nil
        extensions.find do |entry|
          begin
            result = __send__(entry, label, content, visitor)
          rescue NameError
            $stderr.puts $!.inspect
            $stderr.puts $!.backtrace.join("\n")
            raise
          end
        end
        result
      end

      def extensions
        self.class.extensions
      end

    end
  end
end
