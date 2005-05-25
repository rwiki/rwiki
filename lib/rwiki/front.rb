# -*- indent-tabs-mode: nil -*-

require "cgi"
require "drb/drb"
require "rwiki/rw-lib"
require "rwiki/content"
require "rwiki/gettext"

module RWiki

  class Front
    include DRbUndumped
    include GetTextMixin

    def initialize(book)
      @book = book
    end

    def include?(name)
      @book.include_name?(name)
    end

    def find(str)
      @book.find_body(str).collect do |pg|
        pg.name
      end
    end

    def find_all(str)
      @book.find_body(str).each do |pg|
        yield pg
      end
    end

    def view(name, env={}, &block)
      page = @book[name]
      return page.edit_html(env, &block) if page.empty?

      if block
        em ,= block.call('em')
        return page.emphatic_html(env, &block) if em
      end

      page.view_html(env, &block)
    end

    def edit_view(name, rev=nil, env={}, &block)
      @book[name].edit_html(rev=nil, env, &block)
    end

    def submit_view(name, env={}, &block)
      @book[name].submit_html(env, &block)
    end

    def preview_view(name, src, env={}, &block)
      @book[name].preview_html(src, env, &block)
    end

    def emphatic_view(name, env={}, &block)
      @book[name].emphatic_html(env, &block)
    end

    def error_view(name, env={}, &block)
      @book[name].error_html(env, &block)
    end

    def src(name)
      page = @book[name]
      page.empty? ? nil : page.src
    end

    def body(name)
      page = @book[name]
      return nil if page.empty?
      c = Content.new(page.name, page.src)
      c.body
    end
    
    def modified(name)
      @book[name].modified
    end

    def src_view(name, rev=nil, env={}, &block)
      @book[name].src_html(rev, env, &block)
    end
    
    def set_src_and_view(name, src, env={}, &block)
      page = @book[name]
      page.src = src
      page.view_html(env, &block)
    end

    def page(name)
      @book[name]
    end

    def [](name)
      @book[CGI.unescape(name)]
    end

    def default_url(env={})
      Request.default_url(env)
    end
    
    def rd2content(src)
      return {} if src.to_s.empty?
      c = Content.new('tmp', src)
      return {:body => c.body, :links => c.links}
    end

    def process_request(req, env={}, &block)
      result = nil
      begin
        init_gettext(env["locales"] || [], AVAILABLE_LOCALES)
        req.validate
        result = __send__("do_#{req.cmd}", req, env, &block)
      rescue RWiki::InvalidRequest
        result = on_request_error(req, env, $!, $@, &block)
      rescue RWiki::RevisionError
        result = on_revision_error(req, env, $!, $@, &block)
      rescue
        result = on_unknown_error(req, env, $!, $@, &block)
      end
      if result.is_a?(String)
        header = Response::Header.new
        body = Response::Body.new(result)
        body.type = "text/html"
        body.charset = KCode.charset
        result = Response.new(header, body)
      end
      result
    end

    def on_request_error(req, env, error, info, &block)
      header = Response::Header.new(302)
      header.location = default_url(env)
      Response.new(header)
    end

    def on_revision_error(req, env, error, info, &block)
      messages = []
      messages << "#{error.message}\n"
      messages << _("Page '%s' has changed since editing started.
Back to the edit page and press 'RELOAD' to refresh the page,
then retry to merge/add your changes to its latest source.\n") % req.name
      messages << _("Submitted source:\n") + "#{req.src}\n"
      error_response(req.name, env, messages.join("\n"))
    end

    def on_unknown_error(req, env, error, info, &block)
      message = "#{error.message}\n\n" << info.join("\n")
      error_response('error', env, message)
    end

    def error_response(name, env, message)
      name = 'error' unless name
      result = error_view(name, env) do |key|
        case key
        when 'message'
          message
        else
          ''
        end
      end
      header = Response::Header.new(500)
      body = Response::Body.new(result)
      body.type = "text/html"
      body.charset = RWiki::KCode.charset
      body.message = message
      Response.new(header, body)
    end
    
    def recent_changes
      @book.recent_changes.collect do |pg|
        pg.name
      end
    end

    def update_navi(&env)
      if (name = navi_name(env))
        _, navi = @book.navi.find do |title, nv|
          nv.name == name
        end
        unless navi.nil?
          navi.update!
          @book.update_navi
        end
      end
    end

    private
    def navi_name(env)
      get_env_value(env, "navi")
    end

    def get_env_value(env, name)
      if env
        value, = env.call(name)
        value
      else
        nil
      end
    end

    def do_view(req, env={}, &block)
      view(req.name, env, &block)
    end
    
    def do_edit(req, env={}, &block)
      edit_view(req.name, req.rev, env, &block)
    end
    
    def do_src(req, env={}, &block)
      ims = env['if-modified-since']
      page = @book[req.name]
      if ims and page.modified <= ims
        not_modified(req, env, &block)
      else
        header = Response::Header.new
        result = src_view(req.name, req.rev, env, &block)
        body = Response::Body.new(result)
        body.type = "text/html"
        body.charset = KCode.charset
        body.date = page.modified
        Response.new(header, body)
      end
    end

    def do_submit(req, env={}, &block)
      page = @book[req.name]
      page.set_src(req.src, req.rev, &block)
      page.submit_html(env, &block)
    end

    def not_modified(req, env, &block)
      header = Response::Header.new(304)
      header.location = "#{env['base_url']}?#{req.query}"
      Response.new(header)
    end
  end

end
