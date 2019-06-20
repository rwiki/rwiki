require 'digest/md5'
require 'monitor'
require 'rwiki/db/base'
require 'fileutils'
require 'groonga'

module RWiki
  module DB
    class Groonga < Base
      include MonitorMixin

      def initialize(dir)
        super()
        path = ::File.join(dir, 'rwiki.groonga')
        begin
          ::Groonga::Database.open(path)
        rescue
          FileUtils::mkdir_p(dir)
          create_table(path)
        end
        @groonga = ::Groonga['RWiki']
      end

      def import(key, value, mtime, ctime=nil)
        synchronize do
          ctime = mtime if ctime.nil?
          @groonga.add(key, :text => value, :updated_at => mtime, :created_at => ctime)
        end
      end

      private
      def make_digest(src)
        Digest::MD5.hexdigest(src || "")
      end

      def create_table(path)
        ::Groonga::Database.create(:path => path)
        ::Groonga::Schema.create_table('RWiki', :type => :patricia_trie)
        ::Groonga::Schema.change_table('RWiki') do |table|
          table.long_text('text')
          table.timestamps
        end
        ::Groonga::Schema.create_table('Terms',
          :type => :patricia_trie,
          :normalizer => :NormalizerAuto,
          :default_tokenizer => 'TokenBigram')
        ::Groonga::Schema.change_table('Terms') do |table|
          table.index('RWiki.text')
        end
      end

      def set(key, value, opt=nil)
        synchronize do
          it = @groonga.add(key, :text => value)
          return nil unless it
          it.updated_at = Time.now
          it.created_at = it.updated_at if it.created_at == Time.at(0)
        end
        nil
      end

      def _get(key)
        @groonga[key]
      end

      def get(key, rev=nil)
        synchronize do
          it = _get(key)
          it.text
        end
      rescue
        nil
      end

      public
      def modified(key)
        synchronize do
          it = _get(key)
          return it&.updated_at
        end
      rescue
        nil
      end

      def revision(key)
        make_digest(get(key))
      end

      def each(prefix=nil, &blk)
        return to_enum(__method__, prefix) unless block_given?
        if prefix
          synchronize do
            @groonga.open_prefix_cursor(prefix) do |cursor|
              cursor.each {|it| yield(it._key)}
            end
          end
        else
          synchronize do
            @groonga.each {|it| yield(it._key)}
          end
        end
      end
      
      def search(keywords)
        synchronize do
          list = @groonga.select {|r|
            keywords.collect {|w| r.text =~ w}
          }
        end.collect {|r|
          r._key
        }
      end
    end
  end
end
