# -*- indent-tabs-mode: nil -*-

require "erb"
require 'rd/rdfmt'
require 'rwiki/rd/rd2rwiki-lib'

module RWiki

  class Content
    include ERB::Util
    
    EmptyERB = ERB.new('')
    
    def initialize(name, src)
      @name = name
      @body = nil
      @links = []
      @method_list = []
      @src = src
      @body_erb = EmptyERB
      set_src(src)
    end
    attr_reader(:name, :body, :body_erb, :links, :src, :tree)
    attr_reader(:method_list)
    
    private
    def set_src(src)
      @src = src
      if src
        begin
          make_tree
          v = make_visitor
          @body = v.visit(@tree)
          @links = v.links
          @method_list = v.method_list
          prepare_links
        rescue
          @body = "<h1>RD Error</h1>\n"
          @body << "<pre>#{h($!)}</pre>\n"
          @body << "<pre>\n"
          cnt = 2	# '=begin' is the first line.
          @src.each_line do |line|
            @body << "%4d| %s" % [ cnt, h(line) ]
            cnt += 1
          end
          @body << "</pre>\n"
        end
      end
      @body_erb = ERB.new(@body.to_s)
    end
    
    def prepare_links
      old = @links
      @links = old.collect do |link|
        link[0]
      end
      @links.compact!
      @links.uniq!
    end
    
    def make_tree
      @tree = RD::RDTree.new("=begin\n#{@src}\n=end\n")
    end
    
    def make_visitor
      $Visitor_Class.new
    end
  end

end

