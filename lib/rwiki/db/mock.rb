# -*- indent-tabs-mode: nil -*-

require 'monitor'
require 'rwiki/db/base'

module RWiki
  module DB
    class Mock < Base
      include MonitorMixin

      class Entry
        def initialize(old, src)
          @revision = old ? old.revision : 1
          set_src(src)
        end
        attr_reader :revision, :src, :modified

        private
        def set_src(src)
          @src = src
          @modified = Time.now
          @revision += 1
        end
      end

      class NullEntry
        def revision; nil; end
        def src; nil; end
        def modified; nil; end
      end

      def initialize(other = nil)
        super()
        @db = Hash.new
        @null_entry = NullEntry.new
        copy_from(other) if other
      end

      def copy_from(other)
        other.each do |name|
          self[name] = other[name]
        end
      end

      private
      def set(k, v, opt=nil)
        return if v.nil?
        synchronize do
          if v.empty?
            @db.delete(k)
          else
            @db[k] = Entry.new(@db[k], v)
          end
        end
        nil
      end

      def get(k)
        fetch_entry(k) do |entry|
          return entry.src
        end
      end

      def fetch_entry(k)
        synchronize do
          return yield(@db.fetch(k, @null_entry))
        end
      end
      
      public
      def modified(k)
        fetch_entry(k) do |entry|
          return entry.modified
        end
      end

      def revision(k)
        fetch_entry(k) do |entry|
          return entry.revision
        end
      end

      def each
        @db.keys.each do |name|
          yield(name)
        end
      end
    end
  end
end
