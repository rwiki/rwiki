# -*- indent-tabs-mode: nil -*-

require 'monitor'
require 'rwiki/db/base'

module RWiki
  module DB
    class Mock < Base
      include MonitorMixin

      class Entry
        def initialize(old, src, opt=nil)
          if old
            init_with_old(old)
          else
            init
          end
          set_src(src, opt)
        end
        attr_reader :revision, :src, :modified, :logs, :commit_log

        private
        def set_src(src, opt)
          opt ||= {}
          @src = src
          @modified = Time.now
          @revision = @revision.succ
          @commit_log = opt["commit_log"]
          log = Log.new(@revision)
          log.date = @modified
          log.commit_log = @commit_log
          @logs.unshift(log)
        end

        def init_with_old(old)
          @revision = old.revision
          @logs = old.logs.dup
        end

        def init
          @revision = "1"
          @logs = []
        end
      end

      class NullEntry
        def revision; nil; end
        def src; nil; end
        def modified; nil; end
        def logs; []; end
        def commit_log; nil; end
      end

      def initialize(other = nil)
        super()
        @db = Hash.new
        @null_result = [NullEntry.new]
        copy_from(other) if other
      end

      def copy_from(other)
        other.each do |name|
          self[name] = other[name]
        end
      end

      def log(key, rev=nil)
        fetch_entry(key, rev) do |entry|
          return entry.commit_log
        end
      end
      
      private
      def set(key, value, opt=nil)
        return if value.nil?
        synchronize do
          if value.empty?
            @db.delete(key)
          else
            @db[key] ||= []
            @db[key] << Entry.new(@db[key].last, value, opt)
          end
        end
        nil
      end

      def get(key, rev=nil)
        fetch_entry(key, rev) do |entry|
          return entry.src
        end
      end

      def fetch_entry(key, rev=nil)
        synchronize do
          entries = @db.fetch(key, @null_result)
          target = entries.find do |entry|
            entry.revision == rev
          end
          return yield(target || entries.last)
        end
      end
      
      public
      def modified(key)
        fetch_entry(key) do |entry|
          return entry.modified
        end
      end

      def revision(key)
        fetch_entry(key) do |entry|
          return entry.revision
        end
      end

      def logs(key)
        fetch_entry(key) do |entry|
          return entry.logs
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
