# -*- indent-tabs-mode: nil -*-
require 'logger'
require 'uri'
require 'time'

require 'rwiki/rw-lib'

module RWiki
  class Service < Logger::Application
    VERSION = [
      'rwiki/service',
      '$Id$'
    ]
    INTERPRETER_VERSION = [
      'ruby (HTTP interface)',
      "#{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
    ]
    
    def initialize(rwiki, level=INFO, name="RWikiService")
      super(name)
      @rwiki = rwiki
      self.level = level
    end
    
    def serve(req, res)
      @req = req
      @res = res
      @meta_vars = @req.meta_vars
      run
      @req = @res = nil
    end
    
    private
    def run
      prologue
      
      user = remote_user
      message = "#run: Accessed user '#{remote_user}@#{remote_host}'." 
      info(message)
      # debug("The query invoked with: #{@req.inspect}.")
      
      process
    ensure
      epilogue
    end
    
    def process
      env = get_env
      info("Environment: #{env.inspect}")
      params = get_params
      rw_req = parse_request(params, false)
      method = @req.request_method
      response = @rwiki.process_request(method, rw_req, env) {|k| params[k]}
      case response.header.status
      when 300...400
        info("Redirect to '#{response.header.location}'.")
      when 500...600
        info("Error:\n#{response.body.message}")
      end
      debug {"Response:\n#{response.dump}"}
      setup_response(response)
      0
    rescue DRb::DRbConnError
      on_rwiki_server_down
      1
    rescue
      on_unknown_error(env, $!, $@)
      2
    end
    
    def remote_user(default="anonymous")
      @req.user || default
    end
    
    def remote_host(default="unknown")
      meta_var("REMOTE_HOST") || meta_var("REMOTE_ADDR") || default
    end

    def if_modified_since
      ims_str = meta_var("HTTP_IF_MODIFIED_SINCE")
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
      env = Hash.new
      env['base'] = Request.base(@meta_vars)
      env['base_url'] = Request.base_url(@meta_vars)
      env['rw-agent-info'] = [VERSION, INTERPRETER_VERSION]
      env['locales'] = @req.query['locale'] || []
      env['locales'] += @req.accept_language
      env['if-modified-since'] = if_modified_since
      env['need-passphrase'] = true if defined?(RWiki::PASSPHRASE)
      env['link-from-same-host?'] = link_from_same_host?
      env['bot?'] = bot?
      env['remote-user'] = remote_user(nil)
      
      env
    end
    
    def get_params
      params = @req.query
      
      params
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
      setup_response(response)
    end
    
    def on_rwiki_server_down
      header = Response::Header.new(503)
      body = Response::Body.new('RWiki server seems to be down...')
      body.type = "text/plain"
      response = Response.new(header, body)
      debug {"Response:\n#{response.dump}"}
      setup_response(response)
    end
    
    def setup_response(response)
      response.setup_response(@res)
    end
    
    def parse_request(params, do_validate=true)
      debug("REQUEST_URI: #{@req.request_uri}")
      debug("SERVER_NAME: #{@req.host}")
      req = RWiki::Request.parse(params, do_validate)
      info("Request: #{req.inspect}")
      req
    end
    
    # from tDiary
    BOTS = [
      "Googlebot",
      "Hatena Antenna",
      "moget@goo.ne.jp",
      "msnbot",
      "NPBot",
      "ReadOne::XiBot",
      "HyperRobot",
      "Yahoo! Slurp",
      "Openbot",
      "PerMan Surfer",
      "RSSGate",
      "SharpReader",
      "Ask Jeeves/Teoma",
      "Bloglines",
      "RssBandit",
      "Sage",
      "Fresh Search :: Terrar",
      "Pompos",
      "ConveraCrawler"
    ]
    BOT_RE = /(#{BOTS.uniq.join('|')})/i
    
    BOT_IP_ADDRESSES = [
      '61\.210\.[^.]+\..+',
      '218\.217\.61\..+',
    ]
    BOT_IP_ADDRESS_RE = /(#{BOT_IP_ADDRESSES.uniq.join('|')})/i
    
    BOT_HOSTS = [
      'actckw\d+\.adsl\.ppp\.infoweb\.ne\.jp',
    ]
    BOT_HOST_RE = /(#{BOT_HOSTS.uniq.join('|')})/i
    
    def bot?
      BOT_RE.match(meta_var("HTTP_USER_AGENT", "")) or
        BOT_HOST_RE.match(meta_var("REMOTE_HOST")) or
        BOT_IP_ADDRESS_RE.match(meta_var("REMOTE_ADDR"))
    end
    
    def link_from_same_host?
      referer = meta_var("HTTP_REFERER")
      if referer.nil?
        false
      else
        uri = URI.parse(referer)
        uri.host == @req.host
      end
    end
    
    def meta_var(key, default=nil)
      @meta_vars[key] || default
    end
  end
end
