# -*- indent-tabs-mode: nil -*-

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
      @content = nil
      @links = []
      @revlinks = []
      @modified = nil
      @format = nil
      clear_cache

      @hot_order = self.method(:hot_order)
      @hot_links = HotPage.new( &@hot_order )
      @hot_revlinks = HotPage.new( &@hot_order )
      @hot_edges = HotPageContainer.new( &@hot_order )
      @hot_edges << @hot_links << @hot_revlinks
    end
    attr_reader(:name, :links, :revlinks, :modified)
    attr_reader(:body_erb)
    attr_reader(:book, :section)
    attr_writer(:format)
    attr_accessor(:latest_formatted_diff)
    alias title name

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

    def latest_diff
      if logs.size < 2
        nil
      else
        @latest_diff ||= diff(logs[1].revision, logs[0].revision)
      end
    end
    
    def logs
      @logs ||= db.logs(@name)
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

    def format
      if @format.nil?
        @section.format
      else
        @format
      end
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

    def clear_cache
      @logs = nil
      @latest_diff = nil
      @latest_formatted_diff = nil
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

end
