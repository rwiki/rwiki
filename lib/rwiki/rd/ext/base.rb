# -*- indent-tabs-mode: nil -*-
require 'English'
require 'erb'

require 'rwiki/rw-lib'

module RD
  module Ext
    module Util
      include ERB::Util
      extend ERB::Util

      module_function
      def to_attr(hash)
        hash.collect do |key, value|
          "#{h key}='#{h value}'"
        end.join(" ")
      end

      def to_attr_form(hash)
        hash.collect do |key, value|
          "#{key}='#{value}'"
        end.join(" ")
      end
    end
    
    class Base
      include Util
      extend Util
      
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
