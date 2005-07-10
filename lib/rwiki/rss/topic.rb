require "rwiki/rss/page"

RWiki::Version.regist("rwiki/rss/topic",
                      '$Id: rss.rb 582 2005-05-26 02:14:11Z kou $')

module RWiki
  module RSS
    module Topic
      extend ERB::Util

      class << self
        def mutex_attr(id, writable=false)
          module_eval(<<-EOC)
          def self.#{id.id2name}
            @@mutex.synchronize do
              @@#{id.id2name}
            end
          end
          EOC
          mutex_attr_writer(id) if writable
        end

        def mutex_attr_writer(*ids)
          ids.each do |id|
            module_eval(<<-EOC)
            def self.#{id.id2name}=(new_value)
              @@mutex.synchronize do
                @@#{id.id2name} = new_value
              end
            end
            EOC
          end
        end

        def mutex_attr_reader(*ids)
          ids.each do |id|
            mutex_attr(id, false)
          end
        end

        def mutex_attr_accessor(*ids)
          ids.each do |id|
            mutex_attr(id, true)
          end
        end

        @@lang = ::RWiki::PageFormat.module_eval('@@lang')
        @@mutex = Mutex.new

        def clear
          @@mutex.synchronize do
            @@maneger = ::RWiki::RSS::Maneger.new
            @@topics = {}
            @@pages = DISPLAY_PAGES
            @@characters = DISPLAY_CHARACTERS
            @@use_thread = false
            @@display = false
            @@expire = ::RWiki::RSS::EXPIRE
          end
        end

        def forget
          ::RWiki::RSS::Maneger.forget(expire)
        end

        def add_topic(uri, charset, name)
          @@topics[uri] = [charset, name, expire]
        end

        def each_topics(&block)
          if @@display
            parse
            @@maneger.each(&block)
          else
            []
          end
        end

        def parse
          forget
          if @@use_thread
            arg = @@topics.collect {|uri, values| [uri, *values]}
            @@maneger.parallel_parse(arg)
          else
            @@topics.each do |uri, values|
              @@maneger.parse(uri, *values)
            end
          end
        end

      end

      mutex_attr_accessor :use_thread, :pages, :characters
      mutex_attr_accessor :display, :expire
      mutex_attr_reader :topics

      clear

      class Section < RWiki::Section
        def initialize(config, pattern)
          super(config, pattern)
          add_prop_loader(:rss, PropLoader.new)
          add_default_src_proc(method(:default_src))
        end

        path = %w(rss topic default_src.erd)
        RWiki::ERBLoader.new('default_src(name)', path).load(self)
      end


      class PageFormat < RWiki::BookConfig.default.format
        include FormatUtils

        def view(pg)
          topic = ::RWiki::RSS::Topic
          topic.clear
  
          prop = pg.prop(:rss) || {}
          topic.expire = prop[:expire] || ::RWiki::RSS::EXPIRE
          topic.pages = prop[:pages] || ::RWiki::RSS::DISPLAY_PAGES
          topic.characters = prop[:characters] || ::RWiki::RSS::DISPLAY_CHARACTERS
          topic.use_thread = prop[:use_thread]
          topic.display = prop[:display]
          
          (prop[:uri] || []).each do |uri, name|
            topic.add_topic(uri, @@charset, name)
          end
          
          super
        end
        
        private
        def make_topic_title_anchor(channel, name)
          name = channel.title if name.to_s =~ /\A\s*\z/
        %Q!<a href="#{h channel.link.to_s.strip}">#{h name}</a>!
        end
        alias tta make_topic_title_anchor
      
        def make_topic_item_anchor(item, characters)
          href = h(item.link.to_s.strip)
          rv = %Q!<a href="#{href}">#{h item.title.to_s}</a>!
          rv << %Q|(#{h modified(item.dc_date)})|
          cont = item.content
          if cont
            rv << %Q[: #{shorten(cont, characters)} <a href="#{href}">more</a>]
          end
          rv
        end
        alias ttia make_topic_item_anchor

        @rhtml = {
          :navi => RWiki::ERBLoader.new('navi(pg)', %w(rss topic navi.rhtml)),
          :footer => RWiki::ERBLoader.new('footer(pg)', %w(rss topic footer.rhtml)),
        }
        reload_rhtml
      end


      module_function
      def install
        name = "rss_topic"
        pattern = /\A#{Regexp.escape(name)}\z/
        topic_section = Topic::Section.new(nil, pattern)
        RWiki::Book.section_list.push(topic_section)
        RWiki.install_page_module(name, RWiki::RSS::Topic::PageFormat, 'RSS Topic')
        RWiki::BookConfig.default.format = PageFormat
      end
    end
  end
end

RWiki::RSS::Topic.install
