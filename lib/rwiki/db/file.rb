# -*- indent-tabs-mode: nil -*-
# rwiki/db/file.rb
#
# Copyright (c) 2000-2003 Masatoshi SEKI
#
# rwiki/db/file is copyrighted free software by Masatoshi SEKI.
# You can redistribute it and/or modify it under the same term as Ruby.

require 'monitor'
require 'rwiki/db/base'

module RWiki
  module DB
    class File < Base
      include MonitorMixin

      def initialize(path)
        @dir = path.split(::File::Separator)
        super()
      end

      private
      def set(k, v, opt=nil)
        return if v.nil?
        filename = fname(k)
        synchronize do
          if v.empty?
            ::File.unlink(filename)
          else
            ::File.open(filename, 'w') {|fp| fp.write(v) }
          end
        end
      rescue Errno::ENAMETOOLONG
        raise RWikiNameTooLongError.new("name '#{k}' is too long for #{self.class}")
      rescue
        nil
      end

      def get(k)
        filename = fname(k)
        synchronize do
          return nil unless ::File.exist?(filename)
          ::File.open(filename, 'r') {|fp| fp.read }
        end
      rescue
        nil
      end

      public
      def modified(k)
        filename = fname(k)
        return nil unless ::File.exist?(filename)
        stat = ::File.stat(filename)
        return nil if stat.size == 0
        return stat.mtime
      rescue
        nil
      end

      def revision(k)
        make_digest(get(k))
      end

      def each
        Dir[::File.join(@dir + ['*.rd'])].collect do |filename|
          yield(unescape(::File.basename(filename, '.rd')))
        end
      end

      private
      def escape(str)
        str.gsub(/([^a-zA-Z0-9_-])/n){ sprintf("%%%02X", $1.unpack("C")[0]) }
      end

      def unescape(str)
        str.tr('+', ' ').gsub(/((?:%[0-9a-fA-F]{2})+)/n) do
          [$1.delete('%')].pack('H*')
        end
      end

      def fname_old(k)
        ::File.join(*(@dir + [escape(k)]))
      end

      def fname(k)
        fname_old(k) + '.rd'
      end

      def make_digest(src)
        MD5.new(src).hexdigest
      end
    end
  end
end
