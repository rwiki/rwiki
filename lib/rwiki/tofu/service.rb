# -*- indent-tabs-mode: nil -*-
require 'logger'
require 'uri'
require 'time'

require 'rwiki/rw-lib'

module RWiki
  module Tofu
    class Service < Logger::Application
      VERSION = ['rwiki/tofu/service', '$Id$']
      INTERPRETER_VERSION = [
        'ruby (tofu interface)',
        "#{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
      ]
      
      def initialize(rwiki, name="RWikiTofuService")
        super(name)
        @rwiki = rwiki
      end
      
      def start(context)
        @context = context
        super()
        @context = nil
      end
      
      private
      def run
        prologue

        message = "#run: Accessed user '#{remote_user}@#{remote_host}'." 
        info(message)
        # debug("The query invoked with: #{@context.inspect}.")

        process
      ensure
        epilogue
      end

      def process
        env = get_env
        params = get_params
        
        rw_req = RWiki::Request.parse(params, false)
        
        # @context.res_header('Cache-Control', 'no-cache')
        response = @rwiki.process_request(rw_req, env) {|k| params[k]}
        case response.header.status
        when 300...400
          info("Redirect to '#{response.header.location}'.")
        when 500...600
          info("Error:\n'#{response.body.message}'.")
        end
        debug {"Response:\n#{response.dump}"}
        setup_context(response)
        0
      rescue DRb::DRbConnError
        on_rwiki_server_down
        1
      rescue
        on_unknown_error(env, $!, $@)
        2
      end
      
      def remote_user
        @context.req_meta_vars["REMOTE_USER"] || "anonymous"
      end
      
      def remote_host
        @context.req_meta_vars["REMOTE_HOST"] ||
          @context.req_meta_vars["REMOTE_ADDR"] ||
          "unknown"
      end

      def if_modified_since
        ims_str = @context.req_meta_vars["HTTP_IF_MODIFIED_SINCE"]
        if ims_str
          Time.parse(ims_str)
        else
          nil
        end
      end
      
      def prologue
      end
      
      def epilogue
      end

      def fatal(message=nil, &block)
        log(FATAL, message, &block)
      end
      
      def error(message=nil, &block)
        log(ERROR, message, &block)
      end
      
      def warn(message=nil, &block)
        log(WARN, message, &block)
      end
      
      def info(message=nil, &block)
        log(INFO, message, &block)
      end
      
      def debug(message=nil, &block)
        log(DEBUG, message, &block)
      end
      
      def get_env
        absolute_path = @context.req_absolute_path
        script_name = @context.req_script_name.to_s + '/'
        base_url = absolute_path + script_name
        
        env = Hash.new
        env['base'] = script_name
        env['base_url'] = base_url
        env['rw-agent-info'] = [VERSION, INTERPRETER_VERSION]
        env['locales'] = @context.req_params['locale'] || []
        env['locales'] += accept_language
        env['if-modified-since'] = if_modified_since
        if defined?(RWiki::PASSPHRASE)
          env['need-passphrase'] = true
        end
        
        env
      end

      def get_params
        params = @context.req_params

        commit_log_key = "commit_log"
        value = params[commit_log_key]
        if value
          user = remote_user
          params[commit_log_key] = "#{user}:\n#{value}" if user
        end

        params
      end
      
      def accept_language
        accept = @context.req_meta_vars["HTTP_ACCEPT_LANGUAGE"] || ""
        accept.split(',').collect do |entry|
          lang, quality = entry.split(';')
          if /^q=(.+)/ =~ quality
            quality = $1.to_f
          else
            quality = 1.0
          end
          [lang.strip, quality]
        end.sort do |e1, e2|
          e2[1] <=> e1[1]
        end.collect do |lang, quality|
          lang
        end
      end
  
      def on_unknown_error(env, err, info)
        message = "#{err}\n\n" << info.join("\n")
        error_response(env, 'error', message)
      end

      def error_response(env, name, message)
        debug {"Error:\n#{message}"}
        header = Response::Header.new(500)
        body = Response::Body.new(message)
        body.type = "text/plain"
        body.charset = RWiki::KCode.charset
        response = Response.new(header, body)
        debug {"Response:\n#{response.dump}"}
        setup_context(response)
      end
      
      def on_rwiki_server_down
        header = Response::Header.new(503)
        body = Response::Body.new('RWiki server seems to be down...')
        body.type = "text/plain"
        response = Response.new(header, body)
        debug {"Response:\n#{response.dump}"}
        setup_context(response)
      end

      def setup_context(response)
        response.setup_context(@context)
      end
    end
  end
end
