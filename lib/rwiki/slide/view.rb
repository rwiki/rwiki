# -*- indent-tabs-mode: nil -*-

require 'rwiki/format'

module RWiki
  module Slide
    class SlideFormat < PageFormat
      
      def view(pg)
        slide, slide_no, slide_type = slide_info(pg)
        
        return super(pg) unless slide && slide[:index]
        return super(pg) unless slide_no && slide_no > 0
        
        slide_view(pg, slide, slide_no, slide_type)
      end

      def image(pg)
        slide, slide_no, slide_type = slide_info(pg)

        return ''  unless slide && slide[:index]
        return '' unless slide_no && slide_no > 0
        
        slide_image(pg, slide, slide_no, slide_type)
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
      
      def slide_view(pg, slide, slide_no, slide_type)
        view = SlideView.slide_view(pg, slide, slide_no, slide_type, @env, &@block)
        view.view(pg)
      end
      
      def slide_image(pg, slide, slide_no, slide_type)
        view = SlideView.slide_view(pg, slide, slide_no, slide_type, @env, &@block)
        view.image(pg)
      end
      
      def slide?(pg)
        slide = pg.prop(:slide)
        slide && slide[:index] 
      end

      private
      def slide_info(pg)
        slide = pg.prop(:slide)
        slide_var = get_var('slide')
        slide_no = slide_var.to_i rescue 0
        slide_type = get_var('type')

        [slide, slide_no, slide_type]
      end
    end

    module SlideView
      module_function
      @@views = {}
      def install(name, klass)
        @@views[name] = klass
      end

      def views
        @@views
      end
        
      def slide_view(pg, slide, slide_no, slide_type, env, &block)
        slide_view = nil
        if @@views.has_key?(slide_type)
          slide_view = @@views[slide_type].new(slide, slide_no, env, &block)
        else
          slide_view = HTML.new(slide, slide_no, env, &block)
        end
        slide_view
      end

      module Utils
        attr_reader :slide_index, :slide_no
        
        def initialize(slide, slide_no, *args, &block)
          super(*args, &block)
          @slide_index = slide[:index]
          @slide_no = slide_no 
        end

        private
        def first_link(pg)
          make_link(a_first(pg), _("<<"))
        end
        
        def prev_link(pg)
          make_link(a_prev(pg), _("<"))
        end
        
        def next_link(pg)
          make_link(a_next(pg), _(">"))
        end

        def last_link(pg)
          make_link(a_last(pg), _(">>"))
        end

        def make_link(anchor, label)
          if anchor
            "[<a href='#{anchor}'>#{label}</a>]"
          else
            "[#{label}]"
          end
        end

        def a_first(pg)
          return nil unless @slide_no >= 2
          make_a(pg, 1)
        end
        
        def a_prev(pg)
          return nil unless @slide_no >= 2
          make_a(pg, @slide_no - 1)
        end
        
        def a_next(pg)
          return nil unless @slide_no < @slide_index.size
          make_a(pg, @slide_no + 1)
        end

        def a_last(pg)
          return nil unless @slide_no < @slide_index.size
          make_a(pg, @slide_index.size)
        end

        def a_reload(pg)
          make_a(pg, @slide_no)
        end

        def make_a(pg, slide_no)
          params = {
            'slide' => slide_no,
            'type' => type,
          }
          ref_name(pg.name, params)
        end

        def other_type_links(pg)
          links = []
          SlideView.views.each do |name, klass|
            next if name == type
            params = {
              'slide' => @slide_no,
              'type' => name,
            }
            anchor = ref_name(pg.name, params)
            links << "[<a href='#{anchor}'>#{h(klass.label)}</a>]"
          end
          links
        end
      end
    end
  end
end
