=begin
rt2rwiki-lib.rb
$Id: rt2rwiki-lib.rb,v 1.2 2004/05/07 09:43:49 kazu Exp $
=end
require 'rt/rt2html-lib'

module RT

  class RT2RWikiVisitor < RT2HTMLVisitor
    def initialize(rdvisitor)
      super()
      @rdvisitor = rdvisitor
      @rdinlineparser = ::RD::RDInlineParser.new(nil)
    end


    def visit(parsed)
      @style = parsed.style
      super
    end

    def cell_rd_to_html(cell)
			return "" if cell.value.empty?
      parsed = @rdinlineparser.parse(CGI.unescapeHTML(cell.value))
      class << parsed
        alias each_child each
      end
      visited = @rdvisitor.visit_partial_inline(parsed)
      visited.to_s
    end

    def setup
      block('setup') do
        s = %Q[<table]
        @style['table'].each do |key, value|
          s << %Q[ #{key}="#{value}"]
        end
        s << %Q[>\n]
        s << %Q[<caption>#{caption}</caption>\n] if caption
        if @style['tindex']['span']
          s << %Q[<colgroup]
          @style['tindex'].each do |key, value|
            s << %Q[ #{key}="#{value}"]
          end
          s << %Q[>\n]
        end
        if @style['tbody'].size > 0
          @style['tbody']['span'] ||= @rt.column_size - @style['tindex']['span'].to_i
          s << %Q[<colgroup]
          @style['tbody'].each do |key, value|
            s << %Q[ #{key}="#{value}"]
          end
          s << %Q[>\n]
        end
        s
      end
    end

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
              ret << cell_rd_to_html(cell)
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
            ret << cell_rd_to_html(cell)
            ret << '</td>'
          end
          ret << "</tr>\n"
        end
        ret << "</tbody>\n"
      end
    end

  end # RT2RWikiVisitor
end
