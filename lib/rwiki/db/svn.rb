require "svn/core"
require "svn/repos"
require "svn/client"
require "svn/wc"

require 'rwiki/db/file'
require "timeout"

module RWiki
  Version.regist('RWiki::DB::Svn', '$Id$')

  module DB
    class Svn < File

      REVISION_STRINGS = %w(HEAD BASE COMMITTED PREV)
      
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
        ctx = make_context
        ctx.cleanup(@path)
        ctx.update(@path)
        ctx.cleanup(@path)
      end

      def accept_commit_log?
        true
      end
      
      def revision(key)
        filename = fname(key)
        ctx = make_context
        ctx.status(filename, nil, true, true) do |path, status|
          return status.entry.revision.to_s if status.entry
        end
        nil
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
      end

      def gc
        GC.start
      end
      
      def log(key, rev=nil)
        filename = fname(key)
        rev = parse_rev(rev || "COMMITTED")
        ctx = make_context
        message = ctx.log_message(filename, rev)
        if message.empty?
          nil
        else
          KCode.kconv(message)
        end
      end

      def logs(key)
        filename = fname(key)
        return [] unless versioned?(filename)
        ctx = make_context
        result = []
        receiver = Proc.new do |changed_paths, rev, author, date, message|
          log = Log.new(rev.to_s)
          log.author = author
          log.date = date
          log.commit_log = KCode.kconv(message) unless message.empty?
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
        mod1 = nil
        mod2 = nil
        time1 = commited_time(filename, rev1)
        time2 = commited_time(filename, rev2)
        format_diff(out_tmp.read, time1, time2)
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
        rev = opt[:revision]
        if value.empty?
          ctx.rm_f(filename)
        else
          synchronize do
            begin
              ctx.update(filename, rev)
            rescue ::Svn::Error::FS_NO_SUCH_REVISION
              ctx.cleanup(@path) if locked?
              raise Error.new("error while update to revision `#{rev}'", get(key))
            end
            ::File.open(filename, 'w') {|fp| fp.write(value)}
            if versioned?(filename)
              ctx.update(filename)
            else
              ctx.add(filename)
              ctx.propdel("svn:mime-type", filename)
            end
          end
        end
        ctx.commit(filename)
      rescue ::Svn::Error, Error
        # revert
        ctx.revert(filename)
        raise_revision_error($!, key, value)
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
            if rev.nil? or rev == parse_rev(revision(key))
              ::File.open(filename, 'r') {|fp| fp.read}
            else
              make_context.cat(filename, parse_rev(rev))
            end
          else
            nil
          end
        end
      rescue Errno::ENOENT
        nil
      end

      def versioned?(filename)
        versioned = false
        ctx = make_context
        ctx.status(filename, nil, true, true) do |path, status|
          versioned = !status.entry.nil?
        end
        versioned
      end

      def to_revision(str)
        begin
          Integer(str)
        rescue ArgumentError
          str
        end
      end

      def commited_time(filename, rev)
        ctx = make_context
        ctx.log(filename, rev, rev, 1, true, true) do |changed_paths, rev, author, date, message|
          return date
        end
      end

      def format_diff(diff, time1, time2)
        result = diff.dup
        result.sub!(/\AIndex:.+\n=+\n/, '')
        result.sub!(/^--- #{@path}\/(.+)\.rd/) do |x|
          "--- #{unescape($1)}\t#{time1}"
        end
        result.sub!(/^\+\+\+ #{@path}\/(.+)\.rd/) do |x|
          "+++ #{unescape($1)}\t#{time2}"
        end
        result
      end
      
      def make_context(log=nil)
        ctx = ::Svn::Client::Context.new
        set_log(ctx, log) if log
        ctx.add_username_prompt_provider(0) do |cred, realm, may_save|
          cred.username = @author
          cred.may_save = false
        end
        ctx
      end

      def set_log(ctx, log)
        log = KCode.to_utf8(log)
        ctx.set_log_msg_func do |items|
          [true, log]
        end
      end

      def locked?
        ::Svn::Wc.locked?(@path)
      end

      def parse_rev(rev)
        return "HEAD" if rev.nil?
        return rev if valid_revision_string?(rev)
        begin
          Integer(rev)
        rescue ArgumentError
          "HEAD"
        end
      end

      def valid_revision_string?(rev)
        REVISION_STRINGS.include?(rev)
      end
    end
  end
end
