# -*- indent-tabs-mode: nil -*-
=begin
= RWiki::DB::CVS
== How to use
* if you want to replace default db:
    require 'rwiki/db/cvs'
    RWiki::BookConfig.default.db = RWiki::DB::CVS.new(RWiki::DB_DIR)
== copyright
 * copyright (c) 2003 Kazuhiro NISHIYAMA
 * You can redistribute it and/or modify it under the same term as Ruby.
=end

require 'rwiki/db/file'
require 'sync'
require 'thread'
require 'socket'
require "fileutils"

module RWiki
  Version.regist('RWiki::DB::CVS', '$Id$')

  module DB
    class CVS < File
      include Sync_m

      class CVSError < StandardError
        def initialize(error_message, update_result)
          super(error_message)
          @update_result = update_result
        end
        attr_reader :update_result
      end

      Develop = false
      @@cvs_path = '/usr/bin/cvs'
      @@cvs_options = '-fQz3'

      def initialize(path, branch='HEAD')
        super(path)
        @cvs_path = @@cvs_path
        @cvs_options = @@cvs_options
        @repository = ::File.open(::File.join(@dir+%w[CVS Root])){|fp| fp.read.chomp }
        @cvs_options = '-f' if Develop
        self.branch = branch

        @dir_regexp = Regexp.compile(Regexp.quote(::File.join(@dir)))
        @repository_regexp = Regexp.compile(Regexp.quote(@repository))

        @last_cvs_messages = {}
      end

      attr_accessor :cvs_path, :cvs_options
      attr_reader :repository, :branch
      attr_reader :last_cvs_messages

      def branch=(branch)
        @branch = branch
        unless Develop
          make_cvs_command.update
        end
      end

      def accept_commit_log?
        true
      end
      
      private

      def make_cvs_command
        CVSCommand.new(@cvs_path, @cvs_options, @repository, @branch, @dir, self)
      end

      @@write_to_file_message = "write submitted source\n"

      class CVSCommand

        def initialize(cvs_path, cvs_options, repository, branch, dir, db)
          @cvs_path = cvs_path # cvs command path
          @cvs_options = cvs_options
          @repository = repository
          @branch = branch # branch tag or 'HEAD'
          @dir = dir # working directory
          @db = db

          @detail_cmds = []
          @brief_cmds = []
          @outputs = []
          @exit_statuses = []
        end

        attr_reader :detail_cmds, :brief_cmds, :outputs, :exit_statuses

        private

        def detach_io
          require 'fcntl'
          [TCPSocket, ::File].each {|c|
            ObjectSpace.each_object(c) {|io|
              begin
                unless io.closed?
                  io.fcntl(Fcntl::F_SETFD, Fcntl::FD_CLOEXEC)
                end
              rescue SystemCallError,IOError => e
                STDERR.puts io.inspect, e.inspect if $DEBUG
              end
            }
          }
        end

        def run(*args)
          cmd = [@cvs_path, @cvs_options, '-d', @repository, *args]
          @detail_cmds.push cmd if $DEBUG
          pipe = IO::pipe # pipe[0] for read, pipe[1] for write
          pid = exit_status = nil
          Thread.exclusive {
            verbose = $VERBOSE
            # ruby(>=1.8)'s fork terminates other threads with warning messages
            $VERBOSE = nil
            pid = fork {
              $VERBOSE = verbose 
              detach_io
              STDIN.close
              pipe[0].close
              STDOUT.reopen(pipe[1])
              STDERR.reopen(pipe[1])
              pipe[1].close
              STDERR.puts cmd.inspect if Develop
              exec(*cmd)
              exit!(-1)
            }
            $VERBOSE = verbose 
          }
          pipe[1].close
          cvs_output = pipe[0].read
          pid, exit_status = Process.waitpid2(pid)
          return exit_status == 0
        ensure
          @outputs.push cvs_output
          @exit_statuses.push exit_status
          unless exit_status
            Thread.start {
              begin
                until Process.waitpid(pid, Process::WNOHANG)
                  sleep 1
                end
              rescue
                # ignore
              end
            }
          end
        end

        public

        def remove(filename, commit_message='')
          @db.synchronize(Sync::EX) {
            unless @db.entry_exist?(filename)
              ::File.unlink(filename)
              return true
            end
            @brief_cmds.push ['remove', filename]
            run('remove', '-f', '--', filename)
            @brief_cmds.push ['commit', filename, commit_message]
            run('commit', '-m', commit_message, '--', filename)
          }
        end

        def commit(filename, commit_message='')
          @db.synchronize(Sync::EX) {
            unless @db.entry_exist?(filename)
              @brief_cmds.push ['add', filename]
              run('add', '-ko', '--', filename)
            end
            @brief_cmds.push ['commit', filename, commit_message]
            run('commit', '-m', commit_message, '--', filename)
          }
        end

        def update(filename=nil, rev='HEAD', overwrite=false)
          filename ||= ::File.join(@dir)
          rev ||= 'HEAD'
          args = ['update']
          if overwrite
            args.push '-C'
          end
          if rev == 'HEAD'
            args.push '-A'
          else
            args.push '-r', rev
          end
          args.push '--', filename
          @db.synchronize(Sync::SH) do
            if overwrite
              @brief_cmds.push ['update', "revert to #{rev}", filename]
            else
              @brief_cmds.push ['update', rev, filename]
            end
            run(*args)
          end
        end
        
        def log(filename, rev=nil)
          @db.synchronize(Sync::EX) {
            args = ['log']
            args.push('-r', rev) if rev
            args.push('--', filename)
            run(*args)
            @outputs.pop
          }
        end

        def diff(filename, rev1, rev2)
          @db.synchronize(Sync::SH) {
            run("diff", "-u", "-r", rev1, "-r", rev2, "--", filename)
            @outputs.pop
          }
        end
 
      end # class CVSCommand

      public
      def []=(*arg)
        key = arg.shift
        value = arg.pop
        rev = arg.shift
        opt = {
          :query => arg.shift,
          :revision => rev,
        }
        # check_revision(k, rev)
        set(key, store(value), opt)
      end

      private

      def cvs_results_message(cvs_command)
        cvs_results = []
        if $DEBUG
          cvs_command.detail_cmds.each_with_index do |cmd, idx|
            if @@write_to_file_message == cmd
              cvs_results.push cmd
              next
            end
            result = "cvs command detail result (debug mode only):"
            result << " (exit status: #{cvs_command.exit_statuses[idx]})\n"
            result << cmd.inspect << "\n"
            result << cvs_command.outputs[idx].to_s
            cvs_results.push result
          end
        end
        cvs_command.brief_cmds.each_with_index do |cmd, idx|
          if @@write_to_file_message == cmd
            cvs_results.push cmd
            next
          end
          result = "cvs #{cmd.join(': ').gsub(@dir_regexp, 'DB_DIR')}"
          result << " (#{cvs_command.exit_statuses[idx] == 0 ? 'Success' : 'Failure'})\n"
          result << cvs_command.outputs[idx].to_s.gsub(@repository_regexp, 'Repository').gsub(@dir_regexp, 'DB_DIR')
          cvs_results.push result
        end
        cvs_results.join("\n\n")
      end

      def raise_revision_error(cvs_error, key, value, cvs_command)
        raise RevisionError, <<__EOM__
#{cvs_error.message}

#{cvs_results_message(cvs_command)}

Update result:
#{ cvs_error.update_result }
__EOM__
      end

      def set(key, value, opt=nil)
        return if value.nil?
        cvs_command = make_cvs_command
        filename = fname(key)
        query = opt[:query]
        if query
          commit_message = query['commit_log'].to_s
        else
          commit_message = ''
        end
        rev = opt[:revision]
        begin
          unless cvs_command.update(filename, rev)
            raise CVSError.new("error while cvs update to revision `#{rev}'", get(key))
          end
        end
        synchronize(Sync::EX) {
          ::File.open(filename, 'w') {|fp| fp.write(value) }
        }
        cvs_command.detail_cmds.push @@write_to_file_message if $DEBUG
        cvs_command.brief_cmds.push @@write_to_file_message
        cvs_command.exit_statuses.push nil
        cvs_command.outputs.push nil
        count = 0
        begin
          unless cvs_command.update(filename, @branch)
            raise CVSError.new("error while cvs merge to #{@branch}.", get(key))
          end
          count += 1
          raise CVSError.new("[BUG] cvs unexcepted loop", get(key)) if 5 < count
        end until value.empty? ? cvs_command.remove(filename, commit_message) : cvs_command.commit(filename, commit_message)

        @last_cvs_messages[key] = cvs_results_message(cvs_command)
      rescue CVSError
        # revert
        cvs_command.update(filename, @branch, true)
        raise_revision_error($!, key, value, cvs_command)
      end

      def get(key, rev=nil)
        synchronize(Sync::SH) do
          filename = fname(key)
          if ::File.exist?(filename)
            cvs_command = make_cvs_command
            old_rev = revision(key)
            atime = ::File.atime(filename)
            mtime = ::File.mtime(filename)
            begin
              cvs_command.update(filename, rev)
              content = ::File.open(filename, 'r') {|fp| fp.read}
              file = ::File.basename(filename)
              FileUtils.rm_f(filename.sub(/#{Regexp.quote(file)}\z/, ".##{file}.#{rev}"))
              content
            ensure
              cvs_command.update(filename, old_rev)
              ::File.utime(atime, mtime, filename)
            end
          else
            nil
          end
        end
      rescue Errno::ENOENT
        nil
      end

      public
      def modified(key)
        synchronize(Sync::SH) do
          filename = fname(key)
          if ::File.exist?(filename)
            ::File.mtime(filename)
          else
            nil
          end
        end
      rescue Errno::ENOENT
        nil
      end

      def revision(key)
        basename = ::File.basename(fname(key))
        each_cvs_entry do |_, name, rev, *rest|
          return rev if name and ::File.basename(name) == basename
        end
        @branch
      end

      def entry_exist?(filename)
        basename = ::File.basename(filename)
        each_cvs_entry do |_, name, rev, *rest|
          if basename == name
            return true
          end
        end
        false
      end
      
      def logs(target)
        result = []
        log = nil
        make_cvs_command.log(fname(target)).each do |line|
          case line
          when /\Arevision ((?:\d+\.)+\d+)\s/
            log = Log.new($1)
            result.push(log)
          when /\Adate: /
            if log
              line.split(";").each do |param|
                name, *value = param.split(":")
                unless value.empty?
                  value = value.join(":").strip
                  if name == "date" and /\s+[+-]\d\d\d\d\z/ !~ value
                    # offset is not given
                    value << " -0000"
                  end
                  log.send("#{name.strip}=", value)
                end
              end
            end
          when /\Abranches: /
            # not need
          when /\A(-|=)+$/
            if $1 == "=" and log and log.commit_log
              log.commit_log.chomp!
            end
            log = nil
          when "*** empty log message ***\n"
            # no log message
          else
            if log
              log.commit_log ||= ""
              log.commit_log << normalize_log(line)
            end
          end
        end
        result
      end

      def diff(target, rev1, rev2)
        result = ""
        in_body = false
        make_cvs_command.diff(fname(target), rev1, rev2).each do |line|
          case line
          when /\A(---|\+\+\+)\s*\S+\s*(.*)\s*(?:\d+\.)+\d+\n/
            t = Time.parse($2).localtime
            result << "#{$1} #{t}\n" unless in_body
          when /\A@@/
            in_body = true
          end
          result << line if in_body
        end
        result
      end

      def log(target, rev=nil)
        rev ||=  revision(target)
        result = ""
        added = false
        in_header = true
        in_body = false
        make_cvs_command.log(fname(target), rev).each do |line|
          if in_body
            result << line
            added = true
          end
          case line
          when /^-+$/
            in_header = false if in_header
          when /^date:/
            in_body = true if !in_header
          end
        end
        result.sub!(/\n=+\n\z/, '')
        if added and result != "*** empty log message ***"
          result
        else
          nil
        end
      end
      
      private
      def each_cvs_entry
        synchronize(Sync::SH) do
          ::File.foreach(::File.join(@dir+%w[CVS Entries])) do |entry|
            yield(entry.split(/\//))
          end
        end
      end

      def normalize_log(log)
        KCode.kconv(log.gsub(/\\(\d\d\d)/){$1.oct.chr}.gsub(/\\r\\n?/, "\n"))
      end

    end
  end
end
