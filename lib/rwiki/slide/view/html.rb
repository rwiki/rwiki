# -*- indent-tabs-mode: nil -*-

require 'rwiki/slide/view'

module RWiki
  module Slide
    module SlideView
      class HTML < PageFormat

        include Utils

        @@type = "html"
        @@slide_css = nil
        def self.slide_css() @@slide_css; end
        def self.slide_css=(css) @@slide_css = css; end
        def self.label() "HTML"; end
      
        @rhtml = {
          :view => ERBLoader.new('view(pg)', %w(slide view html.rhtml)),
        }
        reload_rhtml

        attr_reader :type
        def initialize(slide, slide_no, env={}, &block)
          super
          @type = @@type
        end

        def slide_title
          @slide_index[0].title
        end
      
        def body(pg, opt={})
          slide = @slide_index[@slide_no-1]
          src = slide.content.to_s
          "<h2>#{h slide.title}</h2>" + ERB.new(src).result(binding)
        end

        def image(pg)
          nil
        end
        
        SlideView.install(@@type, HTML)
      end
    end
  end
end
    
