#!/usr/bin/env ruby
# -*- indnet-tabs-mode: nil -*-

require "rexml/document"
require "fileutils"
require "erb"

include ERB::Util

def expand_ref(str)
  REXML::Text.unnormalize(str)
end

def expand_ext_ref(str, table)
  str.gsub(/%([^\s;]+);/) do |x|
    if table.has_key?($1)
      expand_ref(table[$1])
    else
      p table
      raise $1
    end
  end
end

File.open(File.join(*%W(lib rwiki rd ext entity)) + ".rb", "w") do |out|
  out.print <<-HEADER
require 'rwiki/rd/ext/inline-verbatim'

module RD
  module Ext
    class InlineVerbatim
      
      def ext_inline_verb_entity_reference(label, content, visitor)
        label = label.to_s
        return nil unless /^&([^;]+);(.*)$/ =~ label
        return nil unless Entity::TABLE.include?($1)

        key = $1
        rest = $2
        if rest.empty?
          Entity::TABLE[key]
        else
          rest = visitor.apply_to_Verb(RD::Verb.new(rest))
          Entity::TABLE[key] + rest
        end
      end

      def self.about_ext_inline_verb_entity_reference
        Entity::ABOUT
      end
    end

    module Entity
HEADER

      table = <<-TABLE_CODE
      TABLE = {
TABLE_CODE

      list = <<-LIST_CODE
      LIST = <<ENTITY_LIST
<table class="entity">
  <tr>
    <th>Name</th>
    <th>Value</th>
    <th>Result</th>
    <th>Comment</th>
  </tr>
LIST_CODE

      ext_param = {}
      ARGF.each do |line|
        case line
        when /^<!ENTITY\s+%\s+(\w+)\s+"(\S+)"\s*>/
          # p ["%", $1, $2]
          ext_param[$1] = expand_ref($2)
        when /^<!ENTITY\s+(\w+)\s+"(\S+)"\s*>\s*<!--\s*(.+)\s*-->/
          key = $1
          comment = $3.strip
          value = expand_ext_ref($2.gsub(/&#38;/, '&'), ext_param)

          table << <<-TABLE_ITEM
        # #{comment}
        #{key.dump} => #{value.dump},
TABLE_ITEM

          list << <<-LIST_ITEM
  <tr>
    <td>#{h(key)}</td>
    <td>#{h(value)}</td>
    <td>#{value}</td>
    <td>#{h(comment)}</td>
  </tr>
LIST_ITEM
          # p [key, value, comment, name]
        end
      end

      table << <<-TABLE_CODE
      }
TABLE_CODE

      list << <<-LIST_CODE
</table>
ENTITY_LIST
LIST_CODE

      out.print(table)
      out.print(list)

      out.print(<<-FOOTER)
      
      ABOUT = <<ABOUT
<p>#{h(%Q[entity reference (example: (('&ENTITY_NAME;')))])}</p>
<p>
\#{LIST}
</p>
ABOUT
    end
  end
end
FOOTER

end
