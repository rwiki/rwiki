# -*- indent-tabs-mode: nil -*-
require 'rwiki/rd/ext/base'
require 'rwiki/rd/ext/image'
require 'rwiki/rt/rtextparser'
require 'rwiki/rt/rt2rwiki-lib'

module RD
  module Ext
    class BlockVerbatim < Base
      include Image
      
      def ext_block_verb_quote(label, content, visitor)
        return nil unless /^_$/i =~ label
        content.sub!(/\A[^\n]*\n/, '')
        %Q!<pre>\n#{content}</pre>\n!
      end
      def self.about_ext_block_verb_quote
        h(%Q!If first line is `# _', hide it. For use `*' and so on at a first letter in the block verb.!) # ')
      end
      
      def ext_block_verb_rt(label, content, visitor)
        return nil unless /^rt$/i =~ label
        @rt_visitor = RT::RT2RWikiVisitor.new(visitor)
        @rt_visitor.visit(RT::RTExtParser::parse(content))
      end
      # RTtool's version is not available.
      def self.about_ext_block_verb_rt
        'RTtool is very simple table generator. (with some extension)'
      end
      
      def ext_block_verb_block_quote(label, content, visitor)
        return nil unless /^blockquote$/i =~ label
        cite, title, content = parse_block_quote_content(CGI.unescapeHTML(content))
        result = nil
        attrs = ""
        begin
          tree = RD::RDTree.new("=begin\n#{content}\n=end\n")
          v = RD::RD2RWikiVisitor.new
          result = v.visit(tree)
          attrs << %Q[ cite="#{h(cite)}"] if cite
          attrs << %Q[ title="#{h(title)}"] if title
        rescue
          result = "<h1>RD Error</h1>\n"
          result << "<pre>#{h($!)}</pre>\n"
          result << "<pre>\n"
          cnt = 2 # '=begin' is the first line.
          content.each_line do |line|
            result << "%4d| %s" % [ cnt, h(line) ]
            cnt += 1
          end
          result << "</pre>\n"
          result
        end
        %Q[<blockquote#{attrs}>\n#{result}</blockquote>\n]
      end
      def self.about_ext_block_verb_block_quote
        h(%Q[If first line is `# blockquote', surround content by <blockquote>.]) # '`
      end
      
      def ext_block_verb_img(label, content, visitor)
        return nil unless /^(?:image|img)$/i =~ label
        prop = {}
        content.each do |line|
          if /^(?:#\s*)?(\S+)\s*=\s*(.+)\s*$/ =~ line
            prop[$1] = $2
          end
        end
        return nil if prop['src'].nil?
        src = prop['src']
        desc = prop['description'] || prop['desc'] || src
        image = make_image(visitor, prop['src'], desc, prop)
        if image
          %Q[<p>#{image}</p>]
        else
          nil
        end
      end
      def self.about_ext_block_verb_img
        h(%Q[If first line is `# image', surround content by <blockquote>.]) # '`
      end
      

      private
      def parse_block_quote_content(content)
        opts = {}
        delete_first_line!(content)
        while /\A#\s*(cite)\s*=\s*(\S+)\s*\n/i.match(content) or
            /\A#\s*(title)\s*=\s*([^\n]+)\s*\n/i.match(content)
          opts[$1] = $2.strip
          delete_first_line!(content)
        end
        [opts["cite"], opts["title"], content]
      end
      def delete_first_line!(str)
        str.sub!(/\A[^\n]*\n/, '')
      end

    end # BlockVerbatim
  end # Ext
end # RD
