# rw-lib.rb
#
# Copyright (c) 2000-2001 Masatoshi SEKI
#
# rw-lib.rb is copyrighted free software by Masatoshi SEKI.
# You can redistribute it and/or modify it under the same term as Ruby.

require 'nkf'

module RWiki
  class RWikiError < RuntimeError; end
  class InvalidRequest < RWikiError; end
  class UnknownCommand < InvalidRequest; end
  class RevisionError < RWikiError; end
  class RWikiNameError < RWikiError; end
  class RWikiNameTooLongError < RWikiNameError; end

  module Version
    @list = []

    def each 
      @list.each do |v|
	yield(v[0], v[1])
      end
    end
    
    def regist(mod, ver)
      @list.push([mod, ver])
    end

    module_function :each, :regist
  end

  Version.regist('ruby (server side)', "#{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]")

  module KCode
    attr_reader(:lang, :charset)

    def kconv(s)
      return '' unless s
      return s unless @nkf
      NKF.nkf(@nkf, s)
    end

    def kcode(*args)
      case $KCODE
      when /^[Ee]/
	@lang = 'ja'
	@charset = 'euc-jp'
	@nkf = '-edXm0'
      when /^[Ss]/
	@lang = 'ja'
	@charset = 'Shift_JIS'
	@nkf = '-sdXm0'
      else
	@lang = "en"
	@charset = 'us-ascii'
	@nkf = nil
      end
    end

    private :kcode

    module_function :lang, :charset, :kconv, :kcode
    kcode()
    trace_var(:$KCODE, method(:kcode))
  end

  class Request
    COMMAND = %w(view edit submit src)

    def self.parse(cgi)
      cmd ,= cgi['cmd']
      name ,= cgi['name']
      rev ,= cgi['rev']
      src ,= cgi['src']
      src = KCode.kconv(src) if src
      new(cmd, name, src, rev)
    end

    def self.default_url(env)
      home = new( 'view', RWiki::TOP_NAME )
      base_url(env) + "?" + home.query
    end

    def self.base_url(env)
      return env['base_url'] if env['base_url']

      if env['HTTPS']
        port = (env['SERVER_PORT'] == '443') ? '' : ':' + env['SERVER_PORT'].to_s
        "https://#{ env['SERVER_NAME'] }#{ port }#{ env['SCRIPT_NAME'] }"
      else
        port = (env['SERVER_PORT'] == '80') ? '' : ':' + env['SERVER_PORT'].to_s
        "http://#{ env['SERVER_NAME'] }#{ port }#{ env['SCRIPT_NAME'] }"
      end
    end

    def initialize(cmd, name=nil, src=nil, rev=nil)
      @cmd = cmd
      @name = name
      @src = src
      @rev = rev
      validate
    end
    attr_reader :cmd, :name, :src, :rev

    def query
      "cmd=#{@cmd};name=#{escape(@name)}"
    end

    def inspect
      "cmd: #{ @cmd }, name: #{ @name }, rev: #{ @rev }, src: #{ @src }"
    end

    def validate
      validate_command
      validate_name
    end

    private
    def validate_command
      raise UnknownCommand, @cmd.inspect unless @cmd
      raise UnknownCommand, @cmd.inspect unless COMMAND.include? @cmd
    end

    def validate_name
      raise InvalidRequest unless @name
    end

    def escape( string )
      string.gsub(/([^ a-zA-Z0-9_.\-]+)/n) do
	'%' + $1.unpack('H2' * $1.size).join('%').upcase
      end.tr(' ', '+')
    end
  end
end

