require "svn/core"
require "svn/repos"
require "svn/client"
require "svn/wc"

require 'rwiki/db/file'

module RWiki
  Version.regist('RWiki::DB::Svn', '$Id: cvs.rb 111 2005-01-26 13:38:18Z kou $')

  module DB
    class Svn < File

      class Error < StandardError
        attr_reader :update_result
        def initialize(error_message, update_result)
          super(error_message)
          @update_result = update_result
        end
      end
      
      def initialize(path)
        super(path)
        @path = ::File.join(@dir)
        @author = ENV["USER"] || "rwiki"
        @pool = nil
        @can_cleanup = true
        cleanup
      end

      def accept_commit_log?
        true
      end
      
      def revision(key)
        filename = fname(key)
        if ::File.exist?(filename)
          open_adm do |adm|
            status = adm.status(filename)
            return status.entry.revision.to_s if status.entry
          end
          "HEAD"
        else
          nil
        end
      end

      def []=(*arg)
        key = arg.shift
        value = arg.pop
        rev = parse_rev(arg.shift)
        opt = {
          :query => arg.shift,
          :revision => rev,
        }
        # check_revision(k, rev)
        set(key, store(value), opt)
      end

      def close
        @pool.destroy
      end

      def log(key, rev=nil)
        filename = fname(key)
        rev = parse_rev(rev)
        ctx = make_context
        message = ctx.log_message(filename, rev)
        if message.empty?
          nil
        else
          message
        end
      end

      def logs(key)
        filename = fname(key)
        return [] unless versioned?(filename)
        ctx = make_context
        result = []
        receiver = Proc.new do |changed_paths, rev, author, date, message, pool|
          log = Log.new(rev.to_s)
          log.author = author
          log.date = date
          log.commit_log = message unless message.empty?
          result.unshift(log)
        end
        ctx.log(filename, 0, "HEAD", 0, false, false) do |*args|
          receiver.call(*args)
        end
        result
      end
      
      def diff(key, rev1, rev2=nil)
        filename = fname(key)
        rev1 = to_revision(rev1)
        rev2 = to_revision(rev2 || 'HEAD')
        out_tmp = Tempfile.new("rwiki-db-svn")
        err_tmp = Tempfile.new("rwiki-db-svn")
        ctx = make_context
        ctx.diff([], filename, rev1, filename, rev2,
                 out_tmp.path, err_tmp.path)
        out_tmp.close
        out_tmp.open
        out_tmp.read
      end

      private
      def set(key, value, opt=nil)
        return if value.nil?
        filename = fname(key)
        query = opt[:query]
        if query
          commit_message = query['commit_log'].to_s
        else
          commit_message = ''
        end
        ctx = make_context(commit_message)
        disable_cleanup
        rev = opt[:revision]
        if value.empty?
          ctx.rm_f(filename)
        else
          synchronize do
            begin
              ctx.update(filename, rev)
            rescue ::Svn::Error::FS_NO_SUCH_REVISION
              ctx.cleanup(@wc_path) if locked?
              raise Error.new("error while cvs update to revision `#{rev}'", get(key))
            end
            ::File.open(filename, 'w') {|fp| fp.write(value)}
            ctx.add(filename) unless versioned?(filename)
          end
        end
        ctx.commit(filename)
      rescue ::Svn::Error, Error
        # revert
        ctx.revert(filename)
        raise_revision_error($!, key, value)
      ensure
        enable_cleanup
      end

      def raise_revision_error(error, key, value)
        raise RevisionError, <<__EOM__, caller
#{error.message}

#{key}: #{value}
__EOM__
      end
      
      def get(key, rev=nil)
        synchronize do
          filename = fname(key)
          if ::File.exist?(filename)
            ctx = make_context
            disable_cleanup
            old_rev = parse_rev(revision(key))
            atime = ::File.atime(filename)
            mtime = ::File.mtime(filename)
            begin
              ctx.update(filename, parse_rev(rev))
              ::File.open(filename, 'r') {|fp| fp.read}
            ensure
              if rev and rev != old_rev
                ctx.update(filename, old_rev)
              end
              ::File.utime(atime, mtime, filename)
            end
          else
            nil
          end
        end
      rescue Errno::ENOENT
        nil
      ensure
        enable_cleanup
      end

      def versioned?(filename)
        open_adm do |adm|
          status = adm.status(filename)
          !status.entry.nil?
        end
      end

      def to_revision(str)
        begin
          Integer(str)
        rescue ArgumentError
          str
        end
      end
      
      def make_context(log=nil)
        dirty!
        ctx = ::Svn::Client::Context.new(@pool)
        set_log(ctx, log) if log
        ctx.add_username_prompt_provider(0) do |cred, realm, may_save, pool|
          cred.username = @author
          cred.may_save = false
        end
        ctx
      end

      def set_log(ctx, log)
        ctx.log_msg_func = Proc.new do |items|
          [true, log]
        end
      end

      def open_adm
        dirty!
        ::Svn::Wc::AdmAccess.open(nil, @path, false, 0, @pool) do |adm|
          yield adm
        end
      end

      def locked?
        dirty!
        ::Svn::Wc.locked?(@path, @pool)
      end

      def cleanup
        @dirty = 0
        @pool.destroy if @pool
        @pool = ::Svn::Core::Pool.new
      end

      def dirty!
        @dirty += 1
        cleanup if @can_cleanup and dirty?
      end

      def dirty?
        @dirty >= 25
      end

      def parse_rev(rev)
        return "HEAD" if rev.nil?
        begin
          Integer(rev)
        rescue ArgumentError
          "HEAD"
        end
      end

      def enable_cleanup
        @can_cleanup = true
      end

      def disable_cleanup
        @can_cleanup = false
      end
    end
  end
end
