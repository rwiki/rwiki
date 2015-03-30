# -*- indent-tabs-mode: nil -*-

require "rwiki/bookconfig"

module RWiki

  class Section
    include BookConfigMixin

    def initialize(config, regex = nil)
      super()
      init_with_config(config || BookConfig.default)
      if String === regex
        regex = Regexp.new("^#{Regexp.escape(regex)}$")
      end
      @pattern = regex
      @cache.start
    end

    def match?(name)
      return true if @pattern.nil?
      @pattern =~ name
    end

    def create_page(name, book)
      @page.new(name, book, self)
    end

    def default_src(name)
      @default_src_proc.each do |src_proc|
        it = src_proc.call(name)
        return it unless it.nil?
      end
      ""
    end

    def orphan(book)
      @db.find_all {|name| book[name].orphan?}
    end

    def load_prop(content)
      return nil unless content
      return nil unless content.tree
      result = {}
      @prop_hook.each do |key, loader|
        result[key] = loader.load(content)
      end
      result
    end
  end

end
