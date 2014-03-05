# -*- indent-tabs-mode: nil -*-

require "weakref"
require "drb/drb"
require "rwiki/format"
require 'rwiki/hotpage'
require 'rwiki/content'

module RWiki
  class Page
    include DRbUndumped

    def initialize(name, book, section)
      @section = section
      @book = book
      @name = name
      @src = nil
      @body_erb = nil
      @has_body = false
      @links = []
      @revlinks = []
      @modified = nil
      @method_list = []
      @format = nil
      clear_cache

      @hot_order = self.method(:hot_order)
      @hot_links = HotPage.new( &@hot_order )
      @hot_revlinks = HotPage.new( &@hot_order )
      @hot_edges = HotPageContainer.new( &@hot_order )
      @hot_edges << @hot_links << @hot_revlinks
    end
    attr_reader(:name, :links, :revlinks, :modified, :method_list)
    attr_reader(:body_erb)
    attr_reader(:book, :section)
    attr_writer(:format)
    alias title name

    def revision
      db.revision(@name).to_s
    end

    def int_version
      db.int_version(@name).to_i
    rescue
      -1
    end

    def author
      db.author(@name)
    rescue
      ''
    end

    def diff(rev1, rev2)
      @diffs[[rev1, rev2]] ||= db.diff(@name, rev1, rev2)
    end

    def latest_diff
      if logs.empty?
        nil
      else
        diff(logs[1].revision, logs[0].revision)
      end
    end

    def logs
      @logs ||= db.logs(@name)
    end

    def log(rev=nil)
      @log[rev] ||= db.log(@name, rev)
    end

    def src(rev=nil)
      if rev.nil?
        @src
      else
        db[@name, rev]
      end
    end

    def src=(v)
      set_src(v, nil)
    end

    def set_src(v, rev, &block)
      @book.synchronize do
        @book.dirty
        db[@name, rev, block] = v
        update_src(db[@name])
        clear_cache
      end
      @book.gc
    end

    def move(new_name, src, rev, &block)
      @book.synchronize do
        @book.dirty
        db.move(@name, new_name, src, rev, block)
        update_src(db[@name])
        clear_cache
        new_page = @book[new_name]
        new_page.update_src(db[new_name])
        new_page.clear_cache
      end
      @book.gc
    end

    def annotate(rev=nil)
      db.annotate(@name, rev)
    end

    def format
      if @format.nil?
        @section.format
      else
        @format
      end
    end

    def empty?
      ! @has_body
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
      format.new(env, &block).view(self)
    end

    def edit_html(rev=nil, env = {}, &block)
      format.new(env, &block).edit(self, rev)
    end

    def submit_html(env = {}, &block)
      format.new(env, &block).submit(self)
    end

    def preview_html(src, env = {}, &block)
      format.new(env, &block).preview(self, src)
    end

    def emphatic_html(env = {}, &block)
      format.new(env, &block).emphasize(self)
    end

    def error_html(env = {}, &block)
      format.new(env, &block).error(self)
    end

    def src_html(rev=nil, env = {}, &block)
      format.new(env, &block).src(self, rev)
    end

    def body_html(env = {}, &block)
      format.new(env, &block).body(self)
    end

    def navi_view(title, pg, env = {}, &block)
      format.new(env, &block).navi_view(self, title, pg)
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
      @section.cache.get(@name, v) do |name, value|
        Content.new(@name, value)
      end
    end

    def update_src(v)
      content = make_content(v)
      @src = content.src
      @has_body = ! (@src.nil? || @src.empty?)
      @body_erb = content.body_erb     
      @method_list = content.method_list
      @modified = db.modified(name)
      @prop = @section.load_prop(content)
      unless @links == content.links
        obsolete_links
        @links = content.links
        @hot_links.replace(@links)
      end
      update_links
    end

    def prop(key)
      return nil unless @prop
      @prop[key]
    end

    def clear_cache
      @log = {}
      @logs = nil
      @diffs = {}
    end

    def orphan?
      not(@book.include_name?(@name) && @revlinks.size > 0)
    end

    protected
    def add_link(from)
      @hot_links.set_dirty
    end

    def del_link(from)
    end

    def add_rev_link(from)
      if @revlinks.include? from
        @hot_revlinks.set_dirty
      else
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
    def hot_order(name)
      -1 * (@book[name].modified || Paste).to_f
    end

    def get_weakref_ivar(name)
      obj = instance_variable_get(name)
      if obj.nil? or !obj.weakref_alive?
        obj = WeakRef.new(yield)
        instance_variable_set(name, obj)
      end
      obj
    end
  end
end
