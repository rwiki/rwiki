# -*- indent-tabs-mode: nil -*-

require "monitor"

require "rwiki/bookconfig"
require "rwiki/pagemodule"
require "rwiki/front"
require "drb/drb"

module RWiki

  module TaintMonitor
    def taint_monitor
      self.taint
      @mon_entering_queue.taint
      @mon_waiting_queue.taint
    end
  end

  class Book
    include BookConfigMixin
    include Enumerable
    include MonitorMixin
    include TaintMonitor
    include DRbUndumped

    TOO_DIRTY = 5

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

      disable_gc

      yield(self) if block_given?

      PageModule.each do |name, format, title|
        install_page_module(name, format, title)
      end

      protect_page(TOP_NAME)

      enable_gc
      
      @front = Front.new(self)
    end
    attr_reader :navi, :front

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
    def search_body(regexps)
      regexps = [regexps] unless regexps.respond_to?(:each)
      find_all_by_and_regexp(regexps) {|page, regexp| page.match?(regexp)}
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
      @dirty_count += TOO_DIRTY / 5.0
    end

    def very_dirty
      @dirty_count += TOO_DIRTY
    end

    def bit_dirty
      @dirty_count += TOO_DIRTY / 100.0
    end

    def install_page_module(name, format, title=nil)
      synchronize do
        if name
          pg = protect_gc(name)
          pg.format = format if format
          @navi.push([title, pg]) if title
        else
          # for navi_to_link
          @navi.push([title, format]) if title
        end
      end
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
        return if @dirty_count < TOO_DIRTY
        @dirty_count = 0
        hash = {}
        @extra_page.each do |name, pg|
          active_names(hash, name)
        end
        @fw_table = hash
        @section_list.collect do |section|
          section.db
        end.uniq.each do |db|
          db.gc
        end
      end
    end

    def active_names(hash, root)
      return if hash[root]
      return unless @fw_table[root]
      hash[root] = @fw_table[root]
      hash[root].clear_cache
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
      self.sort_by do |pg|
        # may be 0 when pg.modified == nil 
        -pg.modified.to_i
      end
    end

    private
    def find_all_by_and_regexp(regexps)
      find_all do |page|
        found = false
        regexps.each do |regexp|
          if yield(page, regexp)
            found = true
          else
            found = false
            break
          end
        end
        found
      end
    end
  end
end
