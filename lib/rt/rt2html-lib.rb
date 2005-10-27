=begin
rt2html-lib.rb
$Id: rt2html-lib.rb,v 1.1 2004/04/06 01:41:42 kou Exp $
=end
require 'rt/rtvisitor'

module RT
  class RT2HTMLVisitor < RTVisitor
    OUTPUT_SUFFIX = "html"
    INCLUDE_SUFFIX = ["html"]
    
    def initialize
      super
    end
    
    def block(name)
      %Q[<!-- #{name} -->\n] +
      yield +
      %Q[<!-- #{name} end -->\n\n]
    end
    private :block

    def setup
      block('setup') do
        s = %Q[<table border="1">\n]
        s << %Q[<caption>#{caption}</caption>\n] if caption
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
              ret << cell.value
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
            ret << cell.value
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
if __FILE__ == $0
  require 'runit-init'
  
  include RT
  class RT2HTMLVisitorTest < RUNIT::TestCase
    def setup
      @x = RT2HTMLVisitor::new
      @x.visit(RTParser::parse(<<-END))
      caption = 表テスト

           , 人間, == , 犬 , ==
       ||  , 男  , 女 ,オス,メス

        x  , 1.0 , 2.0, 1.1, 1.2
        y  , 0.4 , 0.5, 0.3, 0.1
      END
    end
    
    def uncomment(str)
      rep = "\001"
      #if str =~ /\A<!--\s+.+?\s+-->\n(.+)<!--\s+.+?\s+-->\n\n\Z/p# POSIX
      if str.gsub(/\n/, rep) =~ /\A<!--\s+.+?\s+-->#{rep}(.+)<!--\s+.+?\s+-->#{rep}#{rep}\Z/
        #$1
        $1.gsub(/#{rep}/, "\n")
      else
        assert_fail("not RTBlock format")
      end
    end
    
    def test_setup
      lines =
        %Q[<table border="1">\n] +
        %Q[<caption>表テスト</caption>\n]
      assert_equal(lines, uncomment(@x.setup))
    end
    
    def test_teardown
      assert_equal(%Q[</table>\n], uncomment(@x.teardown))
    end
    
    def test_visit_Header
      lines =
        %Q[<thead>\n] +
        %Q[<tr><th rowspan="2"></th><th colspan="2">人間</th><th colspan="2">犬</th></tr>\n] +
        %Q[<tr><th>男</th><th>女</th><th>オス</th><th>メス</th></tr>\n] +
        %Q[</thead>\n]
      assert_equal(lines, uncomment(@x.visit_Header))
    end
    
    def test_visit_Body
      lines =
        %Q[<tbody>\n] +
        %Q[<tr><td align="left">x</td><td align="right">1.0</td><td align="right">2.0</td><td align="right">1.1</td><td align="right">1.2</td></tr>\n] +
        %Q[<tr><td align="left">y</td><td align="right">0.4</td><td align="right">0.5</td><td align="right">0.3</td><td align="right">0.1</td></tr>\n] +
        %Q[</tbody>\n]
      assert_equal(lines, uncomment(@x.visit_Body))
    end
    
    def test0
      assert_equal(RT::RTCell, RT::RTCell::new("a").type)
    end

  end
  testrunner RT2HTMLVisitorTest
end


