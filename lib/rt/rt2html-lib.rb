#!/usr/bin/ruby
=begin
rt2html-lib.rb
$Id$
=end
require 'rt/rtvisitor'
require 'cgi'

module RT
  class RT2HTMLVisitor < RTVisitor
    OUTPUT_SUFFIX = "html"
    INCLUDE_SUFFIX = ["html"]
    
    def initialize() super end
    
    def block(name)
      %Q[<!-- #{name} -->\n] +
      yield +
      %Q[<!-- #{name} end -->\n\n]
    end
    private :block

    def esc(str) CGI.escapeHTML(str) end
    private :esc

    def setup
      block('setup') do
        s = %Q[<table border="1">\n]
        s << %Q[<caption>#{esc(caption)}</caption>\n] if caption
        s
      end
    end
    
    def teardown
      block('teardown') do
        %Q[</table>\n]
      end
    end
    
    def cell_element(cell, name)
      rs, cs = cell.rowspan, cell.colspan
      if rs == 1 and cs == 1
        ret = "<#{name}>"
      elsif rs == 1
        ret = %Q[<#{name} colspan="#{cs}">]
      elsif cs == 1
        ret = %Q[<#{name} rowspan="#{rs}">]
      else
        ret = %Q[<#{name} colspan="#{cs}" rowspan="#{rs}">]
      end
      ret
    end
    private :cell_element

    def visit_Header(ary = @header)
      block('Header') do
        if ary.empty?
          ""
        else
          ret = "<thead>\n"
          ary.each do |line|
            ret << '<tr>'
            each_cell(line) do |cell|
              ret << cell_element(cell, 'th')
              ret << esc(cell.value)
              ret << '</th>'
            end
            ret << "</tr>\n"
          end
          ret << "</thead>\n"
        end
      end
    end
    
    def visit_Body(ary = @body)
      block('Body') do
        ret = "<tbody>\n"
        ary.each do |line|
          ret << '<tr>'
          each_cell(line) do |cell|
            ret << cell_element(cell, %Q[td align="#{cell.align.id2name}"])
            ret << esc(cell.value)
            ret << '</td>'
          end
          ret << "</tr>\n"
        end
        ret << "</tbody>\n"
      end
    end
    
  end                           # RT2HTMLVisitor
end
$Visitor_Class = RT::RT2HTMLVisitor
