# -*- indent-tabs-mode: nil -*-

require "cgi"
require "drb/drb"
require "rwiki/rw-lib"
require "rwiki/content"

module RWiki

  class Front
    include DRbUndumped

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

    def view(name, env = {}, &block)
      page = @book[name]
      return page.edit_html(env, &block) if page.empty?

      if block
        em ,= block.call('em')
        return page.emphatic_html(env, &block) if em
      end

      page.view_html(env, &block)
    end

    def edit_view(name, env = {}, &block)
      @book[name].edit_html(env, &block)
    end

    def submit_view(name, env = {}, &block)
      @book[name].submit_html(env, &block)
    end

    def preview_view(name, src, env = {}, &block)
      @book[name].preview_html(src, env, &block)
    end

    def emphatic_view(name, env = {}, &block)
      @book[name].emphatic_html(env, &block)
    end

    def error_view(name, env = {}, &block)
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

    def src_view(name, env = {}, &block)
      @book[name].src_html(env, &block)
    end
    
    def set_src_and_view(name, src, env = {}, &block)
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

    def default_url( env = {} )
      Request.default_url(env)
    end
    
    def rd2content( src )
      return {} if src.to_s.empty?
      c = Content.new('tmp', src)
      return { :body => c.body, :links => c.links }
    end

    def process_request(req, env={}, &block)
      req.validate
      page = @book[req.name]
      case req.cmd
      when 'view'
        view(req.name, env, &block)
      when 'edit'
        page.edit_html(env, &block)
      when 'src'
        page.src_html(env, &block)
      when 'submit'
        page.set_src(req.src, req.rev)
        page.submit_html(env, &block)
      end
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
  end

end
