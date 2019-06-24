# -*- indent-tabs-mode: nil -*-

require "cgi"
require "cgi/util"
require "drb/drb"
require "rwiki/rw-lib"
require "rwiki/content"
require "rwiki/cgi-front"

module RWiki

  class Front
    include DRbUndumped

    def initialize(book)
      @book = book
      @cgi_front = RWiki::CGIFront.new(self)
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

      page.view_html(env, &block)
    end

    def edit_view(name, rev=nil, env={}, &block)
      @book[name].edit_html(rev, env, &block)
    end

    def submit_view(name, env={}, &block)
      @book[name].submit_html(env, &block)
    end

    def preview_view(name, src, env={}, &block)
      @book[name].preview_html(src, env, &block)
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

    def export(port, since)
      n = 0
      @book.each {|x|
        next unless x.modified
        next if x.modified < since
        Marshal.dump([x.name, x.src, x.modified], port)
        n += 1
      }
      n
    end

    def import(port)
      ary = []
      while it = (Marshal.load(port) rescue nil)
        name, src, modified = it
        pg = @book[name]
        next if pg.src == src
        begin
          pg.section.db.import(name, src, modified)
          pg.update_src(src)
          ary << name
        rescue
          p $!
        end
      end
      @book['imported'].src = <<EOS
= import
== #{Time.now}
#{ary.map {|x| "* ((<#{x}>))"}.join("\n")}
EOS
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
      @book[::CGI.unescape(name)]
    end

    def default_url(env={})
      Request.default_url(env)
    end

    def rd2content(src)
      return {} if src.to_s.empty?
      c = Content.new('tmp', src)
      return {:body => c.body, :links => c.links}
    end

    def process_request(method, req, env={}, &block)
      result = header = nil
      begin
        req.validate
        @book.bit_dirty
        method = method.to_s.downcase
        msg = "do_#{method}_#{req.cmd}"
        raise InvalidRequest unless respond_to?(msg, true)
        result, header = __send__(msg, req, env, &block)
      rescue InvalidRequest
        result, header = on_request_error(req, env, $!, $@, &block)
      rescue RevisionError
        result, header = on_revision_error(req, env, $!, $@, &block)
      rescue
        result, header = on_unknown_error(req, env, $!, $@, &block)
      end
      if result.nil? or result.is_a?(String)
        make_response(result, header)
      else
        result
      end
    end

    def on_request_error(req, env, error, info, &block)
      header = Response::Header.new(302)
      header.location = default_url(env)
      Response.new(header)
    end

    def on_revision_error(req, env, error, info, &block)
      messages = []
      messages << "#{error.message}\n"
      messages << "Page '%s' has changed since editing started.
Back to the edit page and press 'RELOAD' to refresh the page,
then retry to merge/add your changes to its latest source.\n" % req.name
      messages << "Submitted source:\n" + "#{req.src}\n"
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
      response = make_response(result, header)
      response.body.message = message
      response
    end

    def recent_changes
      @book.recent_changes.collect do |pg|
        pg.name
      end
    end

    def cgi_start(env, sin, sout)
      @cgi_front.start(env, sin, sout)
    end

    private
    def navi_name(env)
      get_block_value(env, "navi")
    end

    def get_block_value(block, name)
      if block
        value, = block.call(name)
        value
      else
        nil
      end
    end

    def do_get_view(req, env={}, &block)
      page = @book[req.name]

      return do_get_edit(req, env, &block) if page.empty?

      page.view_html(env, &block)
    end

    def do_head_view(req, env={}, &block)
      @book[req.name]
      nil
    end

    def do_get_edit(req, env={}, &block)
      header = Response::Header.new
      header.add('Cache-Control', 'private')
      result = edit_view(req.name, req.rev, env, &block)
      return result, header
    end

    def do_src(need_body, req, env={}, &block)
      ims = env['if-modified-since']
      page = @book[req.name]
      if ims and page.modified <= ims
        not_modified(page.modified, req, env, &block)
      else
        if need_body
          content = src_view(req.name, req.rev, env, &block)
        else
          content = nil
        end
        response = make_response(content)
        response.body.date = page.modified
        response
      end
    end

    def do_get_src(req, env={}, &block)
      do_src(true, req, env, &block)
    end

    def do_head_src(req, env={}, &block)
      do_src(false, req, env, &block)
    end

    def do_post_submit(req, env={}, &block)
      raise InvalidRequest unless req.src

      page = @book[req.name]
      if preview?(req, env, &block)
        page.preview_html(req.src, env, &block)
      else
        src = req.src
        stripped_src = src.to_s.strip
        if stripped_src.empty? or
            stripped_src == @book.default_src(req.name).to_s.strip
          src = ''
        end
        if rename?(req, env, &block)
          rename(src, req, env, &block)
        else
          page.set_src(src, req.rev, &submit_block(env, &block))
          page.submit_html(env, &block)
        end
      end
    end

    def preview?(req, env={}, &block)
      preview = get_block_value(block, "preview")

      unless preview
        phrase = get_block_value(block, "phrase")
        if defined?(RWiki::PASSPHRASE) and RWiki::PASSPHRASE != phrase
          preview = true
        end
      end

      preview
    end

    def rename?(req, env={}, &block)
      get_block_value(block, "rename")
    end

    def rename_force?(req, env={}, &block)
      get_block_value(block, "rename_force")
    end

    def rename(src, req, env, &block)
      new_name = block.call("new_name").to_s.strip
      if new_name.empty?
        edit_view_with_message(:new_name_is_empty, [], req, env, &block)
      else
        page = @book[req.name]
        new_page = @book[new_name]
        if new_page.empty? or rename_force?(req, env, &block)
          page.move(new_name, src, req.rev, &submit_block(env, &block))
          new_page.submit_html(env, &block)
        else
          edit_view_with_message(:destination_page_is_exist, [new_name],
                                 req, env, &block)
        end
      end
    end

    def edit_view_with_message(message, info, req, env, &block)
      edit_view(req.name, req.rev, env) do |key|
        case key
        when "message"
          [message, info]
        when "src"
          req.src
        else
          block.call(key)
        end
      end
    end

    def submit_block(env, &block)
      remote_user = env["remote-user"]
      Proc.new do |key|
        if key == "commit_log" and remote_user
          ["#{remote_user}:\n#{get_block_value(block, key)}"]
        else
          block.call(key)
        end
      end
    end

    def not_modified(modified, req, env, &block)
      header = Response::Header.new(304)
      header.location = "#{env['base_url']}?#{req.query}"
      body = Response::Body.new(nil, 'text/html', modified)
      Response.new(header, body)
    end

    def make_response(content, header=nil)
      header ||= Response::Header.new
      body = Response::Body.new(content)
      Response.new(header, body)
    end
  end
end


