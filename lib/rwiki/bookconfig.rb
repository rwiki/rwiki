# -*- indent-tabs-mode: nil -*-

module RWiki
  
  module BookConfigMixin
    def initialize
      @db = nil
      @format = nil
      @page = nil
      @prop_hook = []
      @default_src_proc = []
    end
    
    def init_with_config(config)
      @db = config.db
      @format = config.format
      @page = config.page
      @prop_hook = config.prop_hook.dup
      @default_src_proc = config.default_src_proc.dup
    end
    
    def add_prop_loader(key, loader)
      @prop_hook.push([key, loader])
    end
    
    def add_default_src_proc(src_proc)
      @default_src_proc.unshift(src_proc)
    end
    attr_accessor :db, :format, :page, :prop_hook, :default_src_proc
  end
  
  class BookConfig
    include BookConfigMixin
    
    def initialize(config=@@default)
      super()
      init_with_config(config) if config
    end
    
    @@default = self.new(nil)
    
    def self.default; @@default; end
  end
  
end
