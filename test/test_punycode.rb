#!/usr/bin/ruby
#
# test of punycode.rb
#
# copyright (c) 2005 Kazuhiro NISHIYAMA
# You can redistribute it and/or modify it under the same terms as Ruby.
#
require 'test/unit'

module AssertPunycode
  def assert_punycode(example)
    example = example.gsub(/\\\n\s*/, "").split(/\n/)
    description = example[0]
    codepoints = example[1...-1].join("")
    punycode = example[-1].strip.sub(/^Punycode: /, "")

    assert_punycode_main(description, codepoints, punycode)
  end

  def test_rfc3492_7_1_A
    assert_punycode(<<-EXAMPLE)
    (A) Arabic (Egyptian):
        u+0644 u+064A u+0647 u+0645 u+0627 u+0628 u+062A u+0643 u+0644
        u+0645 u+0648 u+0634 u+0639 u+0631 u+0628 u+064A u+061F
        Punycode: egbpdaj6bu4bxfgehfvwxn
    EXAMPLE
  end

  def test_rfc3492_7_1_B
    assert_punycode(<<-EXAMPLE)
    (B) Chinese (simplified):
        u+4ED6 u+4EEC u+4E3A u+4EC0 u+4E48 u+4E0D u+8BF4 u+4E2D u+6587
        Punycode: ihqwcrb4cv8a8dqg056pqjye
    EXAMPLE
  end

  def test_rfc3492_7_1_C
    assert_punycode(<<-EXAMPLE)
    (C) Chinese (traditional):
        u+4ED6 u+5011 u+7232 u+4EC0 u+9EBD u+4E0D u+8AAA u+4E2D u+6587
        Punycode: ihqwctvzc91f659drss3x8bo0yb
    EXAMPLE
  end

  def test_rfc3492_7_1_D
    assert_punycode(<<-EXAMPLE)
    (D) Czech: Pro<ccaron>prost<ecaron>nemluv<iacute><ccaron>esky
        U+0050 u+0072 u+006F u+010D u+0070 u+0072 u+006F u+0073 u+0074
        u+011B u+006E u+0065 u+006D u+006C u+0075 u+0076 u+00ED u+010D
        u+0065 u+0073 u+006B u+0079
        Punycode: Proprostnemluvesky-uyb24dma41a
    EXAMPLE
  end

  def test_rfc3492_7_1_E
    assert_punycode(<<-EXAMPLE)
    (E) Hebrew:
        u+05DC u+05DE u+05D4 u+05D4 u+05DD u+05E4 u+05E9 u+05D5 u+05D8
        u+05DC u+05D0 u+05DE u+05D3 u+05D1 u+05E8 u+05D9 u+05DD u+05E2
        u+05D1 u+05E8 u+05D9 u+05EA
        Punycode: 4dbcagdahymbxekheh6e0a7fei0b
    EXAMPLE
  end

  def test_rfc3492_7_1_F
    assert_punycode(<<-EXAMPLE)
    (F) Hindi (Devanagari):
        u+092F u+0939 u+0932 u+094B u+0917 u+0939 u+093F u+0928 u+094D
        u+0926 u+0940 u+0915 u+094D u+092F u+094B u+0902 u+0928 u+0939
        u+0940 u+0902 u+092C u+094B u+0932 u+0938 u+0915 u+0924 u+0947
        u+0939 u+0948 u+0902
        Punycode: i1baa7eci9glrd9b2ae1bj0hfcgg6iyaf8o0a1dig0cd
    EXAMPLE
  end

  def test_rfc3492_7_1_G
    assert_punycode(<<-EXAMPLE)
    (G) Japanese (kanji and hiragana):
        u+306A u+305C u+307F u+3093 u+306A u+65E5 u+672C u+8A9E u+3092
        u+8A71 u+3057 u+3066 u+304F u+308C u+306A u+3044 u+306E u+304B
        Punycode: n8jok5ay5dzabd5bym9f0cm5685rrjetr6pdxa
    EXAMPLE
  end

  def test_rfc3492_7_1_H
    assert_punycode(<<-EXAMPLE)
    (H) Korean (Hangul syllables):
        u+C138 u+ACC4 u+C758 u+BAA8 u+B4E0 u+C0AC u+B78C u+B4E4 u+C774
        u+D55C u+AD6D u+C5B4 u+B97C u+C774 u+D574 u+D55C u+B2E4 u+BA74
        u+C5BC u+B9C8 u+B098 u+C88B u+C744 u+AE4C
        Punycode: 989aomsvi5e83db1d2a355cv1e0vak1dwrv93d5xbh15a0dt30a5j\\
                  psd879ccm6fea98c
    EXAMPLE
  end

  def test_rfc3492_7_1_I
    if self.class.to_s == 'TestPunycodeEncodeLib'
      if $VERBOSE || $DEBUG
        STDERR.puts "SKIP KNOWN BUG: downcase D in Punycode in encode test without case_flags."
      end
      return
    end
    assert_punycode(<<-EXAMPLE)
    KNOWN BUG: downcase D in Punycode in encode test without case_flags. \\
    (I) Russian (Cyrillic):
        U+043F u+043E u+0447 u+0435 u+043C u+0443 u+0436 u+0435 u+043E
        u+043D u+0438 u+043D u+0435 u+0433 u+043E u+0432 u+043E u+0440
        u+044F u+0442 u+043F u+043E u+0440 u+0443 u+0441 u+0441 u+043A
        u+0438
        Punycode: b1abfaaepdrnnbgefbaDotcwatmq2g4l
    EXAMPLE
  end

  def test_rfc3492_7_1_I_downcase
    assert_punycode(<<-EXAMPLE)
    (I) Russian (Cyrillic): (downcase first U in Codepoints and D in Punycode)
        u+043F u+043E u+0447 u+0435 u+043C u+0443 u+0436 u+0435 u+043E
        u+043D u+0438 u+043D u+0435 u+0433 u+043E u+0432 u+043E u+0440
        u+044F u+0442 u+043F u+043E u+0440 u+0443 u+0441 u+0441 u+043A
        u+0438
        Punycode: b1abfaaepdrnnbgefbadotcwatmq2g4l
    EXAMPLE
  end

  def test_rfc3492_7_1_J
    assert_punycode(<<-EXAMPLE)
    (J) Spanish: Porqu<eacute>nopuedensimplementehablarenEspa<ntilde>ol
        U+0050 u+006F u+0072 u+0071 u+0075 u+00E9 u+006E u+006F u+0070
        u+0075 u+0065 u+0064 u+0065 u+006E u+0073 u+0069 u+006D u+0070
        u+006C u+0065 u+006D u+0065 u+006E u+0074 u+0065 u+0068 u+0061
        u+0062 u+006C u+0061 u+0072 u+0065 u+006E U+0045 u+0073 u+0070
        u+0061 u+00F1 u+006F u+006C
        Punycode: PorqunopuedensimplementehablarenEspaol-fmd56a
    EXAMPLE
  end

  def test_rfc3492_7_1_K
    assert_punycode(<<-EXAMPLE)
    (K) Vietnamese:\\
        T<adotbelow>isaoh<odotbelow>kh<ocirc>ngth<ecirchookabove>ch\\
        <ihookabove>n<oacute>iti<ecircacute>ngVi<ecircdotbelow>t
        U+0054 u+1EA1 u+0069 u+0073 u+0061 u+006F u+0068 u+1ECD u+006B
        u+0068 u+00F4 u+006E u+0067 u+0074 u+0068 u+1EC3 u+0063 u+0068
        u+1EC9 u+006E u+00F3 u+0069 u+0074 u+0069 u+1EBF u+006E u+0067
        U+0056 u+0069 u+1EC7 u+0074
        Punycode: TisaohkhngthchnitingVit-kjcr8268qyxafd2f1b9g
    EXAMPLE
  end

  def test_rfc3492_7_1_L
    assert_punycode(<<-EXAMPLE)
    (L) 3<nen>B<gumi><kinpachi><sensei>
        u+0033 u+5E74 U+0042 u+7D44 u+91D1 u+516B u+5148 u+751F
        Punycode: 3B-ww4c5e180e575a65lsy2b
    EXAMPLE
  end

  def test_rfc3492_7_1_M
    assert_punycode(<<-EXAMPLE)
    (M) <amuro><namie>-with-SUPER-MONKEYS
        u+5B89 u+5BA4 u+5948 u+7F8E u+6075 u+002D u+0077 u+0069 u+0074
        u+0068 u+002D U+0053 U+0055 U+0050 U+0045 U+0052 u+002D U+004D
        U+004F U+004E U+004B U+0045 U+0059 U+0053
        Punycode: -with-SUPER-MONKEYS-pc58ag80a8qai00g7n9n
    EXAMPLE
  end

  def test_rfc3492_7_1_N
    assert_punycode(<<-EXAMPLE)
    (N) Hello-Another-Way-<sorezore><no><basho>
        U+0048 u+0065 u+006C u+006C u+006F u+002D U+0041 u+006E u+006F
        u+0074 u+0068 u+0065 u+0072 u+002D U+0057 u+0061 u+0079 u+002D
        u+305D u+308C u+305E u+308C u+306E u+5834 u+6240
        Punycode: Hello-Another-Way--fc4qua05auwb3674vfr0b
    EXAMPLE
  end

  def test_rfc3492_7_1_O
    assert_punycode(<<-EXAMPLE)
    (O) <hitotsu><yane><no><shita>2
        u+3072 u+3068 u+3064 u+5C4B u+6839 u+306E u+4E0B u+0032
        Punycode: 2-u9tlzr9756bt3uc0v
    EXAMPLE
  end

  def test_rfc3492_7_1_P
    assert_punycode(<<-EXAMPLE)
    (P) Maji<de>Koi<suru>5<byou><mae>
        U+004D u+0061 u+006A u+0069 u+3067 U+004B u+006F u+0069 u+3059
        u+308B u+0035 u+79D2 u+524D
        Punycode: MajiKoi5-783gue6qz075azm5e
    EXAMPLE
  end

  def test_rfc3492_7_1_Q
    assert_punycode(<<-EXAMPLE)
    (Q) <pafii>de<runba>
        u+30D1 u+30D5 u+30A3 u+30FC u+0064 u+0065 u+30EB u+30F3 u+30D0
        Punycode: de-jg4avhby1noc0d
    EXAMPLE
  end

  def test_rfc3492_7_1_R
    assert_punycode(<<-EXAMPLE)
    (R) <sono><supiido><de>
        u+305D u+306E u+30B9 u+30D4 u+30FC u+30C9 u+3067
        Punycode: d9juau41awczczp
    EXAMPLE
  end

  def test_rfc3492_7_1_S
    assert_punycode(<<-EXAMPLE)
    (S) -> $1.00 <-
        u+002D u+003E u+0020 u+0024 u+0031 u+002E u+0030 u+0030 u+0020
        u+003C u+002D
        Punycode: -> $1.00 <--
    EXAMPLE
  end

  RUBY_BIN =
    begin
      require "rbconfig"
      File.join(
        Config::CONFIG["bindir"],
        Config::CONFIG["ruby_install_name"] + Config::CONFIG["EXEEXT"]
      )
    rescue LoadError
      "ruby"
    end
  PUNYCODE_RB =
    if File.exist?('punycode.rb')
      'punycode.rb'
    else
      File.expand_path(File.join('..', 'lib', 'punycode.rb'),
                       File.dirname(__FILE__))
    end
end

class TestPunycodeEncode < Test::Unit::TestCase
  include AssertPunycode

  def assert_punycode_main(description, codepoints, punycode)
    IO.popen("#{RUBY_BIN} '#{PUNYCODE_RB}' -e", "r+") do |io|
      io.puts codepoints
      io.close_write
      assert_equal(punycode, io.gets.chomp, description)
    end
  end
end

class TestPunycodeDecode < Test::Unit::TestCase
  include AssertPunycode

  def assert_punycode_main(description, codepoints, punycode)
    IO.popen("#{RUBY_BIN} '#{PUNYCODE_RB}' -d", "r+") do |io|
      io.puts punycode
      io.close_write
      assert_equal(codepoints.strip.gsub(/\s+/, "\n"),
                   io.read.strip, description)
    end
  end
end

if File.executable?("./punycode")
  class TestPunycodeEncodeBin < Test::Unit::TestCase
    include AssertPunycode

    def assert_punycode_main(description, codepoints, punycode)
      IO.popen("./punycode -e", "r+") do |io|
        io.puts codepoints
        io.close_write
        assert_equal(punycode, io.gets.chomp, description)
      end
    end
  end

  class TestPunycodeDecodeBin < Test::Unit::TestCase
    include AssertPunycode

    def assert_punycode_main(description, codepoints, punycode)
      IO.popen("./punycode -d", "r+") do |io|
        io.puts punycode
        io.close_write
        assert_equal(codepoints.strip.gsub(/\s+/, "\n"),
                     io.read.strip, description)
      end
    end
  end
end

begin
  require 'punycode'
  class TestPunycodeEncodeLib < Test::Unit::TestCase
    include AssertPunycode

    def assert_punycode_main(description, codepoints, punycode)
      unistring = codepoints.scan(/[0-9a-fA-F]+/).map{|x|x.hex}.pack('U*')
      assert_equal(punycode, Punycode.encode(unistring), description)
    end
  end

  class TestPunycodeDecodeLib < Test::Unit::TestCase
    include AssertPunycode

    def assert_punycode_main(description, codepoints, punycode)
      unistring = codepoints.scan(/[0-9a-fA-F]+/).map{|x|x.hex}.pack('U*')
      assert_equal(unistring, Punycode.decode(punycode), description)
    end
  end
rescue LoadError
end
