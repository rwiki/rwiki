# -*- indent-tabs-mode: nil -*-

require 'rwiki/rd/rddoc'

module RWiki
  module Slide
    class SlideIndexLoader
      def load(content)
        return nil if content.tree.nil?
        doc = SlideDocument.new(content.tree)
        prop = doc.to_prop
        return nil unless prop
        prop[:name] = content.name
        prop
      end
    end
    
    class Slide
      include RDDoc::TreeUtil
      def initialize(head_node, content_ary)
        @title = as_str(head_node.title)
        @content = content_ary.collect { |n|
          to_html(n)
        }.join("")
      end
      attr_reader :title, :content
    end
    
    class SlideDocument < RDDoc::SectionDocument
      def to_prop
        prop = {}
        ary = []
        each_section do |head, content|
          next unless head
          ary.push(Slide.new(head, content)) if head.level == 1
        end
        return nil if ary.size < 2
        prop[:index] = ary
        prop
      end
    end
  end
  
end
