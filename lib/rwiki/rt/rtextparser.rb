=begin
rtextparser.rb
$Id: rtextparser.rb,v 1.1 2004/04/06 01:41:42 kou Exp $
=end

require 'rt/rtparser'

module RT
  class RTExtParser < RTParser
    def initialize(str=nil)
      super
      @style = {
        'table' => {'border' => '1'},
        'thead' => {},
        'tindex' => {},
        'tbody' => {},
      }
      @column_size = 1
    end
    attr_reader :style, :column_size

    def parse_config(lines = @config_line)
      lines.each do |line|
        case line
        when /^#/               # comment
        when /^\s*(table|thead|tindex|tbody)_(\w+)\s*=\s*([\w#%]+)\s*$/ni
          @style[$1.downcase][$2.downcase] = $3
        when /^\s*(\S+)\s*=\s*(.+)$/
          @config[$1] = $2
        else
          raise "RT: syntax error in config block"
        end
      end
      self
    end

    def parse_table_data(lines)  # iterator
      ret = []
      lines.each do |line|
        case line
        when /^#/             # comment
        else
          column = 0
          ret << split2(line, /\s*#{config['delimiter']}\s*/).collect {|x|
            column += 1
            yield(x.strip, column)
          }
        end
      end
      @column_size = ret[0].size if ret[0]
      if ret.find{|x| x.size != @column_size }
        raise "RT: different column size"
      end
      ret
    end
    private :parse_table_data

    def parse_header(lines = @header_line)
      @header = parse_table_data(lines) {|x, col|
        case x
        when config['rowspan'], config['colspan']
          x
        else
          RTCell::new(x, :center)
        end
      }
      self
    end

    def parse_body(lines = @body_line)
      tindex_span = @style['tindex']['span'].to_i
      @body = parse_table_data(lines) {|x, col|
        case x
        when config['rowspan'], config['colspan']
          x
        else
          if col <= tindex_span
            RTCell::new(x, :center)
          else
            RTCell::new(x)
          end
        end
      }
      self
    end
  end # class RTExtParser
end # module RT
