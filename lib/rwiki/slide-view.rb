require 'rwiki/rwiki'

module Slide
  class SlideFormat < RWiki::PageFormat

    def view(pg)
      slide = pg.prop(:slide)
      slide_var ,= var('slide')
      slide_no = slide_var.to_i rescue 0

      return super(pg) unless slide && slide[:index]
      return super(pg) unless slide_no && slide_no > 0
      
      slide_view(pg, slide, slide_no)
    end

    def navi_view(pg, title, referer)
      if @env[:slide_navi]
	if slide?(pg)
	  %Q[<span class="navi">[<a href="#{ ref_name(pg.name, 'slide' => 1) }">#{ h title }</a>]</span>]
	else
	  ''
	end
      else
	super
      end
    end

    def slide_view(pg, slide, slide_no)
      SlideView.new(slide, slide_no, @env, &@block).view(pg)
    end
    
    def slide?(pg)
      slide = pg.prop(:slide)
      slide && slide[:index] 
    end

  end
  
  class SlideView < RWiki::PageFormat

    @@slide_css = nil
    def self.slide_css() @@slide_css; end
    def self.slide_css=(css) @@slide_css = css; end

    @rhtml = {
      :view => RWiki::ERbLoader.new('view(pg)', 'slide-view.rhtml')
    }
    reload_rhtml
    
    def initialize(slide, slide_no, env = {}, &block)
      super(env, &block)
      @slide_index = slide[:index]
      @slide_no = slide_no 
    end
    attr_reader :slide_index, :slide_no
    
    def slide_title
      @slide_index[0].title
    end

    def body(pg, opt={})
      slide = @slide_index[@slide_no-1]
      src = slide.content.to_s
      "<h2>#{h slide.title}</h2>" + ERB.new(src).result(binding)
    end

    def a_prev(pg)
      return nil unless @slide_no >= 2
      ref_name(pg.name, 'slide' => @slide_no - 1)
    end
    
    def a_next(pg)
      return nil unless @slide_no < @slide_index.size
      ref_name(pg.name, 'slide' => @slide_no + 1)
    end
  end

end
