# -*- indent-tabs-mode: nil -*-

require "monitor"

require "rwiki/bookconfig"
require "rwiki/pagemodule"

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

      PageModule.each do |name, format, title|
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
      sorted_navies = @navi.sort do |x, y|
        y[1] <=> x[1]
      end
      if sorted_navies.empty?
        @header_navi = []
        @footer_navi = []
      else
        if 0 < border and border < 1
          border_index = sorted_navies.size * border
          @header_navi = sorted_navies[0...border_index]
          @footer_navi = sorted_navies[border_index..-1]
        else
          @header_navi, @footer_navi = sorted_navies.partition do |title, nv|
            nv.in_header?(border)
          end
        end
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

end
