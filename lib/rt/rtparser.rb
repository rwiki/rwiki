#!/usr/bin/ruby
=begin
rtparser.rb
$Id: rtparser.rb,v 1.1 2004/04/06 01:41:42 kou Exp $
=end
module RT
  class RTCell
    def initialize(value, align = nil)
      @rowspan = @colspan = 1
      @value = value
      @align = case align       # {:left, :center :right}
               when :left, :center, :right
                 align
               when nil
                 if /^[+\-]?[0-9]+\.?[0-9]*/ === value
                   :right
                 else
                   :left
                 end
               else
                 raise "[BUG]Illegal align type"
               end
    end
    def == (x)
      case x
      when self.class
        self.value == "" && x.value == "" || self.value == x.value && self.align == x.align
      else
        false
      end
    end
    def inspect
      if value==""
        "()"
      else
        a = case align
            when :left
              "l"
            when :center
              "c"
            when :right
              "r"
            else
              raise "[BUG]Illegal align type"
            end
        "#{a}(#{value})"
      end
    end

    attr_reader :value, :align
    attr_accessor :rowspan, :colspan
  end

  class RTParser
    DefaultConfig = {
      'delimiter' => "[,\t]",
      'rowspan'   => "||",
      'colspan'   => "==",
      'escape'    => nil,
      'caption'   => nil,
    }
      
    def initialize(str=nil)
      @str = str
      @config_line = []
      @header_line = []
      @body_line = []
      @config = DefaultConfig.dup
      @header = []
      @body = []
      
      
    end
    attr_reader :str, :config, :header, :body
    
    def self::parse(str)
      obj = self::new str
      obj.make_blocks
      obj.parse_config
      obj.parse_header
      obj.parse_body
      obj.calc_span(obj.header)
      obj.calc_span(obj.body)
      obj
    end
    
    def blocks
      [@config_line, @header_line, @body_line]
    end

    def make_blocks(str = @str)
      part = str.split(/\n\n/).collect{|x| x.split(/\n/)}
      case part.length
      when 0
      when 1
        @body_line, = part
      when 2
        @config_line, @body_line = part
      when 3
        @config_line, @header_line, @body_line = part
      else
        raise "RT: blocks are too many."
      end
      self
    end
    
    def parse_config(lines = @config_line)
      lines.each do |line|
        case line
        when /^#/               # comment
        when /^\s*(\S+)\s*=\s*(.+)$/
          @config[$1] = $2
        else
          raise "RT: syntax error in config block"
        end
      end
      self
    end
    
    def split2(str,re)
      ret = str.split(re, -1)
    end
    private :split2

    ESCAPE_TMP = "\001\002"
    def _escape!(str)
      esc = config['escape']
      str.gsub!(/#{Regexp.quote(esc)}#{config['delimiter']}/, ESCAPE_TMP)  if esc
    end
    private :_escape!

    def _unescape!(str)
      str.gsub!(/#{ESCAPE_TMP}/, config['delimiter'])
    end
    private :_unescape!

    def parse_table_data(lines)  # iterator
      ret = []
      lines.each do |line|
        case line
        when /^#/             # comment
        else
          _escape! line
          ret << split2(line, /\s*#{config['delimiter']}\s*/).collect {|x|
            _unescape! x
            yield(x.strip)
          }
        end
      end
      unless ret.find_all{|x| x.length == ret[0].length} == ret
        raise "RT: different column size"
      end
      ret
    end
    private :parse_table_data

    def _make_cell(x, align)
      case x
      when config['rowspan'], config['colspan']
        x
      else
        RTCell::new(x, align)
      end
    end
    private :_make_cell

    def parse_header(lines = @header_line)
      @header = parse_table_data(lines) {|x|
        _make_cell x, :center
      }
      self
    end

    def parse_body(lines = @body_line)
      @body = parse_table_data(lines) {|x|
        _make_cell x, nil
      }
      self
    end
    
    def calc_span(tbl)
      return if tbl.empty?
      cols = tbl[0].length
      tbl.each do |row|
        row.each_with_index do |elm, j|
          case elm
          when String
          when RTCell
            nspan = 1
            1.upto(cols-j-1) do |k|
              break unless row[j+k] == config['colspan']
              nspan += 1
            end
            row[j].colspan = nspan
          else
            raise "[BUG] invalid cell"
          end
        end
      end
      
      rows = tbl.length
      0.upto(cols-1) do |j|
        0.upto(rows-1) do |i|
          case tbl[i][j]
          when String
          when RTCell
            nspan = 1
            1.upto(rows-i-1) do |k|
              break unless tbl[i+k][j] == config['rowspan']
              nspan += 1
            end
            tbl[i][j].rowspan = nspan
          else
            raise "[BUG] invalid cell"
          end
        end
      end
    end    
  end                           # class RTCell, RTParser
end                             # module RT

      
