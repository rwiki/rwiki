require "rwiki/rd/rddoc"
require "rwiki/rss/maneger"

require "nkf"

class ERB
  module Util
    public
    def html_unescape(s)
      s.to_s.gsub(/&lt;/, "<").gsub(/&gt;/, ">").gsub(/&quot;/, '"').gsub(/&amp;/, "&")
    end
    alias hu html_unescape
  end
end

module RWiki
  module RSS
    
    DISPLAY = true unless const_defined?(:DISPLAY)
    DISPLAY_PAGES = 5 unless const_defined?(:DISPLAY_PAGES)
    DISPLAY_CHARACTERS = 20 unless const_defined?(:DISPLAY_CHARACTERS)
    TRUE_VALUES = ["はい", "yes", "true"] unless const_defined?(:TRUE_VALUES)

    class PropLoader
      def load(content)
        doc = Document.new(content.tree)
        prop = doc.to_prop
        prop[:name] = content.name
        prop
      end
    end

    class Document < RDDoc::SectionDocument
      def to_prop
        prop = {}
        each_section do |head, content|
          next unless head
          if head.level == 2
            case title = as_str(head.title).strip.downcase
            when 'cache', 'キャッシュ'
              CacheSection.new(prop).apply_Section(content)
            when 'display', '表示'
              DisplaySection.new(prop).apply_Section(content)
            when 'servers', 'サーバ'
              URISection.new(prop).apply_Section(content)
            when 'thread', 'スレッド'
              ThreadSection.new(prop).apply_Section(content)
            end
          end
        end
        prop
      end
    end

    class PropSection < RDDoc::PropSection
      def apply_Item(str)
        if /^([^:]*):\s*(.*)$/ =~ str
          apply_Prop($1.strip, $2.strip)
        end
      end
    end

    class CacheSection < PropSection
      def apply_Prop(key, value)
        super(key, value)
        case key.downcase
        when '有効期間', '有効期限', 'expire'
          @prop[:expire] = value.to_i * 60
          @prop[:expire] = EXPIRE if @prop[:expire] < MINIMUM_EXPIRE
        end
      end
    end

    class DisplaySection < PropSection
      def apply_Prop(key, value)
        super(key, value)
        case key.downcase
        when '表示', 'display'
          if TRUE_VALUES.include?(value.strip.downcase)
            @prop[:display] = true
          else
            @prop[:display] = false
          end
        when '件数', 'pages'
          @prop[:pages] = value.to_i
          @prop[:pages] = DISPLAY_PAGES if @prop[:pages].zero?
        when '文字数', 'characters'
          @prop[:characters] = value.to_i
          if @prop[:characters].zero?
            @prop[:characters] = DISPLAY_CHARACTERS
          end
        end
      end
    end

    class ThreadSection < PropSection
      def apply_Prop(key, value)
        super(key, value)
        case key.downcase
        when '使う', 'use'
          if TRUE_VALUES.include?(value.strip.downcase)
            @prop[:use_thread] = true
          else
            @prop[:use_thread] = false
          end
        end
      end
    end

    class URISection < PropSection
      def initialize(*args)
        super
        @prop[:uri] = {}
      end

      def apply_Prop(key, value)
        super(key, value)
        @prop[:uri][value] = key
      end
    end

    module FormatUtils

      def make_anchor(href, name, time=nil, image_src=nil, image_title=nil)
        anchor = if image_src
                   image_title ||= name
                   %Q[<img src="#{h image_src}" title="#{h image_title}" alt="#{h image_title}" />]
                 else
                   h(name)
                 end
        %Q[<a href="#{h href}" title="#{h name} #{make_modified(time)}" class="#{modified_class(time)}">#{anchor}</a>]
      end

      def make_channel_anchor(channel, image, name=nil)
        name = channel.title if name.to_s =~ /\A\s*\z/
        if image
          image_src = image.url
          image_title = image.title
        else
          image_src = nil
          image_title = nil
        end
        make_anchor(channel.link, name, channel.dc_date, image_src, image_title)
      end
      alias ca make_channel_anchor

      def make_item_anchor(item)
        make_anchor(item.link.strip, item.title, item.dc_date)
      end
      alias ia make_item_anchor

      def make_modified(date)
        %Q[(#{h modified(date)})]
      end

      def make_anchors_and_modified(channel, image, item, name=nil)
        "#{ca(channel, image, name)}: #{ia(item)} #{make_modified(item.dc_date)}"
      end
      alias am make_anchors_and_modified

      def make_uri_anchor(uri, name)
        %Q|<a href="#{h uri}">#{h name} : #{h uri}</a>|
      end
      alias ua make_uri_anchor

      def maneger
        @maneger ||= ::RWiki::RSS::Maneger.new
      end

      def localtime(time)
        if time.respond_to?(:localtime)
          time.localtime
        else
          time
        end
      end

      def extract_text_from_html(html)
        html.to_s.gsub(/([^<]*)(<[^>]*>)?/, '\1')
      end

      def shorten(text, len=120)
        text = hu(text).gsub(/\n/, ' ')
        if len < 0
          lines = [text]
        else
          lines = NKF.nkf("-e -m0 -f#{len}", text).split(/\n/)
        end
        lines[0] << '...' if lines[0] and lines[1]
        h(RWiki::KCode.kconv(lines[0]))
      end

    end

  end
end
