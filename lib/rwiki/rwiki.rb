# -*- indent-tabs-mode: nil -*-
# rwiki.rb
#
# Copyright (c) 2000-2003 Masatoshi SEKI
#
# rwiki.rb is copyrighted free software by Masatoshi SEKI.
# You can redistribute it and/or modify it under the same term as Ruby.

require 'monitor'
require 'rd/rdfmt'
require 'rwiki/rd/rd2rwiki-lib'
require 'rwiki/rw-lib'
require 'rwiki/hotpage'
require 'rwiki/navi'
require 'rwiki/db/navi'
require 'rwiki/db/file'
require 'rwiki/rd/rddoc'
require 'drb/drb'
require 'erb'
require 'md5'

module RWiki

  module TaintMonitor
    def taint_monitor
      self.taint
      @mon_entering_queue.taint
      @mon_waiting_queue.taint
    end
  end

  Version.regist('rwiki server', '2003-12-28 2.1.0')

  class Content
    include ERB::Util

    EmptyERB = ERB.new('')

    def initialize(name, src)
      @name = name
      @body = nil
      @links = []
      @labels = []
      @method_list = []
      @src = src
      @body_erb = EmptyERB
      set_src(src)
    end
    attr_reader(:name, :body, :body_erb, :links, :src, :tree)
    attr_reader(:labels, :method_list)

    private
    def set_src(src)
      @src = src
      if src
        begin
          make_tree
          v = make_visitor
          @body = v.visit(@tree)
          @links = v.links
          @labels = v.labels
          @method_list = v.method_list
          prepare_links
        rescue
          @body = "<h1>RD Error</h1>\n"
          @body << "<pre>#{h($!)}</pre>\n"
          @body << "<pre>\n"
          cnt = 2	# '=begin' is the first line.
          @src.each_line do |line|
            @body << "%4d| %s" % [ cnt, h(line) ]
            cnt += 1
          end
          @body << "</pre>\n"
        end
      end
      @body_erb = ERB.new(@body.to_s)
    end

    def prepare_links
      old = @links
      @links = old.collect do |link|
        link[0]
      end
      @links.compact!
      @links.uniq!
    end

    def make_tree
      @tree = RD::RDTree.new("=begin\n#{@src}\n=end\n")
    end

    def make_visitor
      RD::RD2RWikiVisitor.new
    end
  end

  class ERbLoader
    def initialize(method_name, fname, dir=nil)
      @dir = dir
      @fname = fname
      @method_name = method_name
    end

    def load(mod)
      reload(mod)
    end

    def reload(mod)
      fname = build_fname(@fname, @dir)
      erb = File.open(fname) {|f| ERB.new(f.read)}
      erb.def_method(mod, @method_name, fname)
    end
    
    private
    def build_fname(fname, dir)
      case dir
      when String
        ary = [dir]
      when Array
        ary = dir
      else
        ary = $:
      end
      
      found = fname # default
      ary.each do |dir|
        path = File::join(dir, fname)
        if File::readable?(path)
          found = path
          break
        end
        path = File::join(dir, 'rwiki', fname)
        if File::readable?(path)
          found = path
          break
        end
      end
      found
    end
  end    

  class PageFormat
    include ERB::Util

    @@address = ADDRESS
    @@mailto = MAILTO
    @@css = CSS
    @@title = TITLE
    @@lang = LANG || KCode.lang
    @@charset = CHARSET || KCode.charset

    def navi_view(pg, title, referer)
      %Q[<span class="navi">[<a href="#{ ref_name(pg.name) }">#{ h title }</a>]</span>]
    end

    def modified(t)
      return '-' unless t
      dif = (Time.now - t).to_i
      dif = dif / 60
      return "#{dif}m" if dif <= 60
      dif = dif / 60
      return "#{dif}h" if dif <= 24
      dif = dif / 24
      return "#{dif}d"
    end

    def modified_class(t)
      return 'dangling' unless t
      dif = (Time.now - t).to_i
      dif = dif / 60
      return "modified-hour" if dif <= 60
      dif = dif / 60
      return "modified-today" if dif <= 24
      dif = dif / 24
      return "modified-month" if dif <= 30
      return "modified-year" if dif <= 365
      return "modified-old"
    end

    def initialize(env = {}, &block)
      @env = env
      @block = block
      @env[:tabindex] ||= 0
    end

    def var(key)
      @block ? @block.call(key) : []
    end

    def get_var(name, default='')
      val, = var(name)
      val || default
    end

    def env(key)
      @env[key]
    end

    def ref_url(url)
      h(url)
    end

    def ref_name(name, params = {}, cmd = 'view')
      page_url =
        if env('ref_name')
          env('ref_name').call(cmd, name, params)
        else
          program = env('base')
          req = Request.new(cmd, name)
          program.to_s + "?" + req.query +
            params.collect{|k,v| ";#{u(k)}=#{u(v)}" }.join('')
        end
      ref_url(page_url)
    end

    def full_ref_name(name, params = {}, cmd = 'view')
      page_url = "#{env('base_url')}?#{Request.new(cmd, name).query}" +
        params.collect{|k,v| ";#{u(k)}=#{u(v)}" }.join('')
      ref_url(page_url)
    end

    def form_action
      env('base')
    end

    def form_hidden(name, cmd = 'view')
      # req = Request.new(cmd, name) ???
      %Q[<input type="hidden" name="cmd" value="#{cmd}" />] +
        %Q[<input type="hidden" name="name" value="#{h(name)}" />]
    end

    def body(pg, opt = {})
      str = pg.body_erb.result(binding)
      if opt.has_key?(:key)
        # Copy keys from UI side.
        keys = opt[:key].collect { |i| i.dup }
        str = hilighten(str, keys)
      end
      %Q[<div class="body">#{str}</div>]
    end

    def link_and_modified(pg, params={})
      %Q[<a href="#{ref_name(pg.name, params)}">#{h(pg.name)}</a> (#{h(modified(pg.modified))})]
    end

    MaxModTimeIdx = 10
    def hotbar(modTime)
      idx = if modTime.is_a?(Time)
          ( MaxModTimeIdx + 1 ) / (( Time.now - modTime ) / 86400 + 1 ).to_f
        else
          modTime
        end.to_i
      if ( idx < 0 )
        idx = 0
      end
      if 0 < idx
        %Q[<span class="hotbar">#{ '*' * idx }</span>]
      else
        ''
      end
    end

    def tabindex
      @env[:tabindex] += 1
      %Q[tabindex="#{@env[:tabindex]}"]
    end

    @rhtml = {}
    @rhtml[:header] = ERbLoader.new('header(pg)', 'header.rhtml')
    @rhtml[:navi] = ERbLoader.new('navi(pg)', 'navi.rhtml')
    @rhtml[:footer] = ERbLoader.new('footer(pg)', 'footer.rhtml')
    @rhtml[:view] = ERbLoader.new('view(pg)', 'view.rhtml')
    @rhtml[:edit] = ERbLoader.new('edit(pg)', 'edit.rhtml')
    @rhtml[:submit] = ERbLoader.new('submit(pg)', 'submit.rhtml')
    @rhtml[:emphasize] = ERbLoader.new('emphasize(pg)', 'emphasize.rhtml')
    @rhtml[:error] = ERbLoader.new('error(pg)', 'err.rhtml')
    @rhtml[:src] = ERbLoader.new('src(pg)', 'src.rhtml')


    def self.reload_rhtml
      if @rhtml.nil?
        return
      end
      @rhtml.each do |k, v|
        v.reload(self)
      end
    end

    reload_rhtml

    private
    def hilighten(str, keywords)
      hilighted = str.dup
      keywords.each do |key|
        re = Regexp.new('(' << Regexp.escape(h(key)) << ')', Regexp::IGNORECASE)
        hilighted.gsub!(/([^<]*)(<[^>]*>)?/) {
          body, tag = $1, $2
          body.gsub(re) {
            %Q[<em class="hilight">#{$1}</em>]
          } << ( tag || "" )
        }
      end
      hilighted
    end

    def erb_result(pg, erb_or_str, opt={})
      if String === erb_or_str
        str = erb_or_str
        return str unless str.include?('<%')
        erb = ERB.new(str)
      else
        erb = erb_or_str
      end
      erb.result(binding)
    end
  end

  class NaviFormat < PageFormat
    def always_header?
      false
    end
    
    def navi_view(pg, title, referer)
      %Q[<span class="navi">[<a href="#{ ref_name(pg.name, {'navi' => pg.name}) }">#{ h title }</a>]</span>]
    end
  end

  class SearchFormat < NaviFormat
    @rhtml = { :view => RWiki::ERbLoader.new('view(pg)', 'search.rhtml')}
    reload_rhtml

    def navi_view(pg, title, referer)
      %Q|<form action="#{ form_action() }" method="get" class="search">\n<div class="search">\n| <<
        %Q|#{form_hidden('search')}\n| <<
        %Q|<input name="navi" type="hidden" value="#{ h(pg.name) }" size="10" #{tabindex} accesskey="K" />\n| <<
        %Q|<input name="key" type="text" value="#{ h(var('key')) }" size="10" #{tabindex} accesskey="K" />\n| <<
        %Q|<input name="submit" type="submit" value="#{ h title }" #{tabindex} accesskey="G" />\n| <<
        %Q|</div>\n</form>\n|
    end
  end

  class SrcFormat < NaviFormat
    def navi_view(pg, title, referer)
      %Q[<span class="navi">[<a href="#{ ref_name(referer.name, {'navi' => pg.name}, 'src') }">#{ h title }</a>]</span>]
    end
  end

  class EditFormat < NaviFormat
    def navi_view(pg, title, referer)
      %Q[<span class="navi">[<a href="#{ ref_name(referer.name, {'navi' => pg.name}, 'edit') }">#{ h title }</a>]</span>]
    end
  end

  class Page
    include DRbUndumped

    def initialize(name, book, section)
      @section = section
      @book = book
      @name = name
      @src = nil
      @body_erb = nil
      @content = nil
      @links = []
      @revlinks = []
      @modified = nil
      @format = PageFormat
      @logs = db.logs(@name)

      @hot_order = self.method(:hot_order)
      @hot_links = HotPage.new( &@hot_order )
      @hot_revlinks = HotPage.new( &@hot_order )
      @hot_edges = HotPageContainer.new( &@hot_order )
      @hot_edges << @hot_links << @hot_revlinks
    end
    attr_reader(:name, :src, :links, :revlinks, :modified, :logs)
    attr_reader(:body_erb)
    attr_reader(:book, :section)
    attr_accessor(:format)

    %w[labels method_list].each do |meth|
      eval <<-METHOD, binding, __FILE__, __LINE__+1
        def #{meth}
          @content.#{meth}
        end
      METHOD
    end

    def revision
      db.revision(@name).to_s
    end

    def diff(rev1, rev2)
      db.diff(@name, rev1, rev2)
    end

    def src=(v)
      set_src(v, nil)
    end

    def set_src(v, rev, &block)
      @book.synchronize do
        @book.dirty
        db[@name, rev, block] = v
        update_src(db[@name])
        @logs = db.logs(@name)
      end
      @book.gc
    end

    def empty?
      src.nil? || src == ''
    end

    def contain?(str)
      return false if empty?
      src.downcase.index(str.downcase) ? true : false
    end

    def match?(regexp)
      return false if empty?
      regexp =~ src
    end

    def view_html(env = {}, &block)
      @format.new(env, &block).view(self)
    end

    def edit_html(env = {}, &block)
      @format.new(env, &block).edit(self)
    end

    def submit_html(env = {}, &block)
      @format.new(env, &block).submit(self)
    end

    def emphatic_html(env = {}, &block)
      @format.new(env, &block).emphasize(self)
    end

    def error_html(env = {}, &block)
      @format.new(env, &block).error(self)
    end

    def src_html(env = {}, &block)
      @format.new(env, &block).src(self)
    end
    
    def body_html(env = {}, &block)
      @format.new(env, &block).body(self)
    end

    def navi_view(title, pg, env = {}, &block)
      @format.new(env, &block).navi_view(self, title, pg)
    end

    def hot_links
      @hot_links.pages.uniq
    end

    def hot_revlinks
      @hot_revlinks.pages.uniq
    end

    def hot_edges
      @hot_edges.pages.uniq
    end

    # For backward compatibility.
    def hotlinks
      hot_edges.collect { |name| @book[name] }
    end

    def next_pages
      revlinks.collect { |name|
        pg = @book[name]
        pg.links[pg.links.index(@name) + 1]
      }.compact.uniq
    end

    def prev_pages
      revlinks.collect { |name|
        pg = @book[name]
        index = pg.links.index(@name)
        (index > 0) ? pg.links[index - 1] : nil
      }.compact.uniq
    end

    def make_content(v)
      Content.new(@name, v)
    end

    def update_src(v)
      obsolete_links

      content = make_content(v)
      @src = content.src
      # @body_erb = ERB.new(@body, 4)
      @body_erb = content.body_erb
      @links = content.links
      @content = content
      @modified = db.modified(name)
      @prop = @section.load_prop(content)
      @hot_links.replace(@links)

      update_links
    end

    def prop(key)
      return nil unless @prop
      @prop[key]
    end

    protected
    def add_link(from)
      @hot_links.set_dirty
    end

    def del_link(from)
    end

    def add_rev_link(from)
      unless @revlinks.include? from
        @revlinks.push from
        @hot_revlinks << from
      end
    end

    def del_rev_link(from)
      @revlinks.delete(from)
      @hot_revlinks.delete(from)
    end

    def db
      @section.db
    end

    private
    def update_links
      @links.each do |to|
        @book[to].add_rev_link(@name) unless to == @name
      end
      @revlinks.each do |from|
        @book[from].add_link(@name) unless from == @name
      end
    end

    def obsolete_links
      @links.each do |to|
        @book[to].del_rev_link(@name) unless to == @name
      end
      @revlinks.each do |from|
        @book[from].del_link(@name) unless from == @name
      end
    end

    def <=>(rhs)
      @name <=> rhs.name
    end

    Paste = Time.at(0)
    def hot_order( a, b )
      a = @book[a].modified || Paste
      b = @book[b].modified || Paste
      b <=> a
    end

  end

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
      RWiki::Request.default_url(env)
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

  module BookConfigMixin
    def initialize
      @db = nil
      @format = nil
      @page = nil
      @prop_hook = []
      @default_src_proc = []
    end
    
    def init_with_config(config)
      @db = config.db
      @format = config.format
      @page = config.page
      @prop_hook = config.prop_hook.dup
      @default_src_proc = config.default_src_proc.dup
    end
    
    def add_prop_loader(key, loader)
      @prop_hook.push([key, loader])
    end

    def add_default_src_proc(src_proc)
      @default_src_proc.unshift(src_proc)
    end
    attr_accessor :db, :format, :page, :prop_hook, :default_src_proc
  end

  class BookConfig
    include BookConfigMixin

    def initialize(config=@@default)
      super()
      init_with_config(config) if config
    end

    @@default = self.new(nil)

    def self.default; @@default; end
  end

  BookConfig.default.db = DB::File.new(DB_DIR)
  BookConfig.default.format = PageFormat
  BookConfig.default.page = Page
  BookConfig.default.add_default_src_proc(proc {|name| "= #{name}\n\n"})

  class Section
    include BookConfigMixin

    def initialize(config, regex = nil)
      super()
      init_with_config(config || BookConfig.default)
      if String === regex
        regex = Regexp.new("^#{Regexp.escape(regex)}$")
      end
      @pattern = regex
    end

    def match?(name)
      return true if @pattern.nil?
      @pattern =~ name
    end
    
    def create_page(name, book)
      pg = @page.new(name, book, self)
      pg.format = @format
      pg
    end
    
    def default_src(name)
      @default_src_proc.each do |src_proc|
        it = src_proc.call(name)
        return it unless it.nil?
      end
      ""
    end

    def orphan(book)
      @db.find_all { |name|
        not(book.include_name?(name) && book[name].revlinks.size > 0)
      }
    end
    
    def load_prop(content)
      return nil if content.src.nil?
      return nil unless content
      return nil unless content.tree
      result = {}
      @prop_hook.each do |key, loader|
        result[key] = loader.load(content)
      end
      result
    end
  end

  class NaviPage < Page
    @rrd = ERbLoader.new('to_rd(_count, _meta_info)', 'navi.rrd')
    @rrd.reload(self)

    attr_accessor :info_db

    def initialize(name, book, section)
      super
      @info_db = DB::Navi.new(self, book.default_max_navi_value)
    end

    def update_src(v)
      super
      meta = meta_info
      @info_db.updatable = meta["updatable"]
      @info_db.border = meta["border"]
      @info_db.max = meta["max"] if meta["max"]
      @info_db.count = count
      @book.update_navi
    end

    def store(count)
      meta = {}
      meta_info.each do |name, value|
        meta[name] = @info_db.__send__(name)
      end
      self.src = to_rd(count, meta)
    end
    
    private
    def count
      property[:counts] || {}
    end

    def meta_info
      property[:meta] || {}
    end

    def property
      prop(:navi) || {}
    end

  end

  class NaviSection < Section
    def initialize(config, name)
      super
      @format = NaviFormat
      @page = NaviPage
      add_prop_loader(:navi, PropLoader.new)
    end
    
    class PropLoader
      def load(content)
        ps = RDDoc::PropSection.new()
        counts = {}
        meta = {}
        info = {
          :counts => counts,
          :meta => meta,
        }
        if content.tree
          ps.apply_Section(content.tree.root)
          ps.prop.each do |name, value|
            case name
            when /\A(?:border|max)\z/
              meta[name] = value.to_i
            when /\Aupdatable\z/
              meta[name] = value == "true"
            else
              counts[name] = value.to_i
            end
          end
        end
        info
      end
    end
  end

  class Book
    include BookConfigMixin
    include Enumerable
    include MonitorMixin
    include TaintMonitor

    @@section_list = []
    def self.section_list; @@section_list; end

    def initialize(config=BookConfig.default, section_list=@@section_list)
      super()
      taint_monitor()
      
      @root_section = Section.new(config)
      @section_list = section_list
      
      @dirty_count = 0
      @extra_page = {}
      @fw_table = {}
      @navi = []
      
      @toplevel = true
      @pending = []

      @border = 300
      @default_max_navi_value = 1000
      
      disable_gc
      
      yield(self) if block_given?
      
      init_navi("navi", config)

      RWiki::PageModule.each do |name, format, title|
        install_page_module(name, format, title)
      end

      protect_page('help')

      enable_gc
    end
    attr_reader :navi, :header_navi, :footer_navi
    attr_accessor :default_max_navi_value
    
    def section(name)
      @section_list.each do |sec|
        return sec if sec.match?(name)
      end
      return @root_section
    end

    def create_page(name)
      section(name).create_page(name, self)
    end

    def [](name)
      sec = section(name)
      synchronize do 
        obj = @fw_table[name]
        return obj if obj
        obj = create_page(name)
        @fw_table[name] = obj
        toplevel = @toplevel
        @toplevel = false
        if toplevel
          obj.update_src(sec.db[name])
          while pg = @pending.pop
            pg.update_src(sec.db[pg.name]) if pg.empty?
          end
        else
          @pending.push(obj)
        end
        @toplevel = toplevel
        obj
      end
    end

    def each
      synchronize do
        @fw_table.each_value do |page|
          yield page
        end
      end
    end

    def orphan
      ary = @root_section.orphan(self)
      @section_list.each do |sec|
        ary.concat(sec.orphan(self))
      end
      ary.uniq.sort
    end

    def size
      @fw_table.size
    end
    
    def find_title(str)
      self.find_all { |page| page.name.downcase.index(str.downcase) }
    end

    # Bare in mind that the argument regexp must be trusted.
    def search_title(regexp)
      self.find_all { |page| regexp =~ page.name }
    end

    def find_body(str)
      self.find_all { |page| page.contain? str }
    end

    # Bare in mind that the argument regexp must be trusted.
    def search_body(regexp)
      self.find_all { |page| page.match? regexp }
    end

    alias find_str find_body

    def protect_page(name)
      synchronize do
        pg = self[name]
        @extra_page[name] = pg
        return pg
      end
    end
    alias protect_gc protect_page

    def include_name?(name)
      @fw_table.include?(name)
    end

    def dirty
      @dirty_count += 1
    end

    def install_page_module(name, format, title=nil)
      synchronize do
        if name
          pg = protect_gc(name)
          pg.format = format if format
          @navi.push([title, Navi.new(pg, @navi_db)]) if title
        else
          # for navi_to_link
          @navi.push([title, Navi.new(format, @navi_db)]) if title
        end
        update_navi
      end
    end

    def front
      Front.new(self)
    end

    def disable_gc
      @gc = false
    end

    def enable_gc
      @gc = true
    end

    def gc
      synchronize do
        return unless @gc
        return if @dirty_count > 5
        @dirty_count = 0
        hash = {}
        @extra_page.each do |name, pg|
          active_names(hash, name)
        end
        @fw_table = hash
      end
    end

    def active_names(hash, root)
      return if hash[root] 
      return unless @fw_table[root]
      hash[root] = @fw_table[root]
      hash[root].links.each do |name|
        active_names(hash, name) unless hash[name]
      end
    end

    def default_src(name)
      section(name).default_src(name)
    end

    def load_prop(content)
      section(content.name).load_prop(content)
    end

    def recent_changes
      past = Time.at(1)
      self.sort do |a, b|
        (b.modified || past) <=> (a.modified || past)
      end
    end

    def border
      @navi_db.border || @border
    end

    def border=(new_border)
      @border = new_border
      update_navi
    end
    
    def update_navi
      @header_navi, @footer_navi = @navi.sort do |x, y|
        y[1] <=> x[1]
      end.partition do |title, nv|
        nv.in_header?(border)
      end

      if @header_navi.empty?
        @header_navi, @footer_navi = @footer_navi, @header_navi
      else
        always_header_navi, @footer_navi = @footer_navi.partition do |title, nv|
          nv.always_header?
        end
        @header_navi += always_header_navi.sort {|x, y| y[1] <=> x[1]}
      end
    end

    private
    def init_navi(navi_page_name, config)
      @section_list.push(NaviSection.new(config, navi_page_name))
      navi_page = protect_page(navi_page_name)
      @navi_db = navi_page.info_db
    end
    
  end

  # default page modules
  PageModule = []

  def self.install_page_module(name, format, title=nil)
    PageModule.push([name, format, title])
  end

  navi_to_link = Object.new
  class << navi_to_link
    def navi_view(title, pg, env = {}, &block)
      %Q[<span class="navi">[<a href="#link">#{ title }</a>]</span>]
    end
    def name
      "link"
    end
    def always_header?
      true
    end
  end

  [
    [RWiki::TOP_NAME, NaviFormat, 'Home'],
    [nil, navi_to_link, 'Link'],
    ["src", SrcFormat, 'Src'],
    ["edit", EditFormat, 'Edit'],
    ['help', NaviFormat, 'Help'],
    ['search', SearchFormat, 'Search'],
  ].each do |args|
    install_page_module(*args)
  end

  def self.reload_rhtml
    ObjectSpace.each_object(Class) do |o|
      o.reload_rhtml if o.ancestors.include?(PageFormat)
    end
  end
end
