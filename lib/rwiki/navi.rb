# -*- indent-tabs-mode: nil -*-

require "rwiki/page"
require "rwiki/format"
require "rwiki/section"
require 'rwiki/db/navi'
require 'rwiki/rd/rddoc'

module RWiki

  class Navi

    def initialize(formatter, db)
      @formatter = formatter
      @db = db
    end

    def <=>(other)
      self.priority <=> other.priority
    end

    def navi_view(*args, &block)
      @formatter.navi_view(*args, &block)
    end
    
    def in_header?(border)
      priority >= border
    end

    def always_header?
      if @formatter.respond_to?(:always_header?)
        @formatter.always_header?
      end
    end
    
    def update!
      @db.update!(name)
    end

    def priority
      @db[name]
    end

    def name
      @formatter.name
    end

  end

  class NaviPage < Page
    @rrd = ERBLoader.new('to_rd(_count, _meta_info)', 'navi.rrd')
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

  class NaviFormat < PageFormat
    def always_header?
      false
    end
    
    def navi_view(pg, title, referer)
      %Q[<span class="navi">[<a href="#{ ref_name(pg.name, {'navi' => pg.name}) }">#{ h title }</a>]</span>]
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
            when /\Aborder\z/
              meta[name] = value.to_f
            when /\Amax\z/
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

end
