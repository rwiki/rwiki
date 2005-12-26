# -*- indent-tabs-mode: nil -*-

require 'drb'

require 'rwiki/front'
require 'rwiki/rw-lib'
require 'rwiki/slide/view'

module RWiki
  module Slide
    module SlideView
      class Rabbit < PageFormat

        include Utils

        @@type = "rabbit"
        @@drb_uri = nil
        def self.drb_uri() @@drb_uri; end
        def self.drb_uri=(uri) @@drb_uri = uri; end
        def self.label() "Rabbit"; end

        @rhtml = {
          :view => ERBLoader.new('_view(pg)', %w(slide view rabbit.rhtml)),
        }
        reload_rhtml

        attr_reader :type
        def initialize(slide, slide_no, env={}, &block)
          super
          @type = @@type
          @drb_uri = @@drb_uri || "druby://localhost:10101"
          @rabbit = DRbObject.new_with_uri(@drb_uri)
          @rabbit.version # try
        end

        def image(pg)
          setup_current_page
          [@rabbit.current_slide_image, "image/#{@rabbit.image_type}"]
        end

        def view(pg)
          src = KCode.to_utf8(pg.src)
          if @rabbit.source != src
            @rabbit.source = src
          end
          setup_current_page
          _view(pg)
        end

        private
        def slide_navi(pg)
          return '' unless @rabbit.accept_move?
          html = "<div class='navi'>\n"
          html << "#{normal_view_link(pg)}\n"
          html << "#{first_link(pg)}\n"
          html << "#{prev_link(pg)}\n"
          html << "#{next_link(pg)}\n"
          html << "#{last_link(pg)}\n"
          other_type_links(pg).each do |link|
            html << "#{link}\n"
          end
          html << "</div>\n"
          html
        end

        def normal_view_link(pg)
          make_link(ref_name(pg.name), h(KCode.kconv(@rabbit.title)))
        end

        def image_path(pg)
          params = {
            'slide' => @slide_no,
            'type' => type,
          }
          ref_name(pg.name, params, "image")
        end

        def setup_current_page
          if @rabbit.accept_move?
            @rabbit.move_to_if_can(@slide_no - 1)
          end
        end

        SlideView.install(@@type, Rabbit)
      end
    end
  end

  Request::COMMAND.concat(%w(image))

  class Front
    def image_view(name, env={}, &block)
      page = @book[name]
      format = page.format.new(env, &block)
      format.image(page)
    end

    def do_get_image(req, env={}, &block)
      make_image_response(*image_view(req.name, env, &block))
    end

    def make_image_response(content, type=nil)
      if type.nil?
        header = Response::Header.new(500)
        body = Response::Body.new('', 'text/plain')
      else
        header = Response::Header.new
        body = Response::Body.new(content, type)
      end
      Response.new(header, body)
    end
  end

end
