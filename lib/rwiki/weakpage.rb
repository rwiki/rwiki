# -*- indent-tabs-mode: nil -*-

require 'monitor'
require 'rwiki/rw-lib'
require 'rwiki/bookconfig'
require 'rwiki/page'

module RWiki
  Version.regist('weakpage', '2003-02-19')
  
  class WeakPool
    class WeakPoolError < RuntimeError; end
    class WeakPoolEntry
      def initialize(pool)
        @pool = pool
      end
      
      def get_obj
        @pool.fetch(self)
      end
    end
    
    include MonitorMixin
    def initialize(n=50)
      super()
      @hash = {}
      @recent = Array.new(n)
    end
    
    def store(obj)
      synchronize do
        key = WeakPoolEntry.new(self)
        @hash[key] = obj
        add_key(key)
        key
      end
    end
    
    def fetch(key)
      synchronize do
        raise WeakPoolError unless @hash.include?(key)
        rotate_key(key)
        return @hash[key]
      end
    end
    
    def replace(key, obj)
      synchronize do
        if @hash.include?(key)
          rotate_key(key)
        else
          add_key(key)
        end
        @hash[key] = obj
      end
      key
    end
    
    private
    def add_key(key)
      synchronize do
        @recent.push(key)
        del = @recent.shift
        unless del.nil?
          @hash.delete(del)
          GC.start
        end
      end
    end
    
    def rotate_key(key)
      synchronize do
        @recent.delete(key)
        @recent.push(key)
      end
    end
  end
  
  class WeakPage < Page
    
    @@pool = WeakPool.new
    
    def initialize(name, book, section)
      super(name, book, section)
      @empty = true
    end
    
    def update_src(v)
      obsolete_links
      
      content = make_content(v)
      @src = nil
      if content.src.to_s.size == 0
        @empty = true
      else
        @empty = false
      end
      self.body_erb = content.body_erb
      @links = content.links
      @content = content
      @modified = db.modified(name)
      @prop = @book.load_prop(content)
      @hot_links.replace(@links)
      
      update_links
    end
    
    def body_erb=(erb)
      if @body_erb
        @@pool.replace(@body_erb, erb)
      else
        @body_erb = @@pool.store(erb)
      end
    end
    
    def empty?
      @empty
    end
    
    def src
      db[@name]
    end
    
    def body_erb
      begin
        raise "@body_erb=nil" if @body_erb.nil?
        @body_erb.get_obj
      rescue
        content = make_content(src)
        self.body_erb = content.body_erb
        content.body_erb
      end
    end
  end
  
  BookConfig.default.page = WeakPage
end

