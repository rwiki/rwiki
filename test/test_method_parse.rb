require 'test/unit'
require 'rwiki/rd/rd2rwiki-lib'

class TestMethodParse < Test::Unit::TestCase
  DummyElement = Object.new

  def assert_parse_method(expected, expected_klass, expected_kind, expected_method, method)
    v = RD::RD2RWikiVisitor.new
    assert_equal(expected, v.__send__(:parse_method, method, DummyElement), "parse_method")
    element, klass, kind, method = v.method_list[0]
    assert_equal(DummyElement, element, "element")
    assert_equal(expected_klass, klass, "klass")
    assert_equal(expected_kind, kind, "kind")
    assert_equal(expected_method, method, "method")
  end

  def test_parse_method_global_variable
    global_variables.sort.each do |str|
      assert_parse_method(str, nil, :global_variable, str, str)
    end
    %w|$1 $2 $3|.each do |str|
      assert_parse_method(str, nil, :global_variable, str, str)
    end
  end

  def test_parse_method_self_binary_op_other
    %w'+ - * / % ** <=> == < <= > >= | & ^ << >> ==='.each do |op|
      str = "self #{op} other" # recommended pattern
      assert_parse_method("<var>self</var> #{op} <var>other</var>",
                          nil, nil, op, str)

      str = "self #{op}other" # not recommended pattern
      case op
      when '&'
        # parse as block
        assert_parse_method("<var>self</var> <var>#{op}other</var>",
                            nil, nil, "<var>#{op}other</var>", str)
      else
        assert_parse_method("<var>self</var> #{op}<var>other</var>",
                            nil, nil, "#{op}<var>other</var>", str)
      end

      str = "self#{op} other" # not recommended pattern
      assert_parse_method("self#{op} <var>other</var>",
                          nil, nil, "self#{op}", str)

      str = "self#{op}other" # not recommended pattern
      assert_parse_method("self#{op}other",
                          nil, nil, "self#{op}other", str)
    end
  end

  def test_parse_method_unary_op_self
    %w'+ - ~'.each do |op|
      str = "#{op} self"
      assert_parse_method("#{op} <var>self</var>",
                          nil, nil, op, str)
      str = "#{op}self"
      assert_parse_method("#{op}self",
                          nil, nil, "#{op}self", str)
    end
  end

  def test_parse_method_self_aref_and_aset
    assert_parse_method("self[](<var>key</var>)",
                        nil, nil, "self[]",
                        "self[](key)")
    assert_parse_method("self[]=(<var>key</var>, <var>value</var>)",
                        nil, nil, "self[]=",
                        "self[]=(key, value)")
    assert_parse_method("self[]=(<var>key</var>,<var>value</var>)",
                        nil, nil, "self[]=",
                        "self[]=(key,value)")

    assert_parse_method("self[start..end]",
                        "self[start.", :class_method, "end]",
                        "self[start..end]")
    assert_parse_method("self[start, <var>length</var>]",
                        nil, nil, "self[start,",
                        "self[start, length]")
    assert_parse_method("self[nth]=val",
                        nil, nil, "self[nth]=val",
                        "self[nth]=val")
    assert_parse_method("self[start..end]=val",
                        "self[start.", :class_method, "end]=val",
                        "self[start..end]=val")
    assert_parse_method("self[start, <var>length</var>]=<var>val</var>",
                        nil, nil, "self[start,",
                        "self[start, length]=val")
    assert_parse_method("self[start,length]=val",
                        nil, nil, "self[start,length]=val",
                        "self[start,length]=val")
  end

  def test_parse_method_aref_and_aset
    assert_parse_method("[<var>key</var>]",
                        nil, nil, "[]",
                        "[](key)")
    assert_parse_method("[<var>key</var>] = <var>value</var>",
                        nil, nil, "[]=",
                        "[]=(key, value)")
    assert_parse_method("[<var>key</var>] = <var>value</var>",
                        nil, nil, "[]=",
                        "[]=(key,value)")
  end

  def test_parse_method_klass_aref_and_aset
    assert_parse_method("Array[item,...]",
                        "Array[item,..", :class_method, "]",
                        "Array[item,...]")
    assert_parse_method("Dir[pattern]",
                        nil, nil, "Dir[pattern]",
                        "Dir[pattern]")
    assert_parse_method("ENV[key]",
                        nil, nil, "ENV[key]",
                        "ENV[key]")
    assert_parse_method("ENV[key]=value",
                        nil, nil, "ENV[key]=value",
                        "ENV[key]=value")

    assert_parse_method("Dir[](<var>pattern</var>)",
                        nil, nil, "Dir[]",
                        "Dir[](pattern)")
    assert_parse_method("ENV[](<var>key</var>)",
                        nil, nil, "ENV[]",
                        "ENV[](key)")
    assert_parse_method("ENV[]=(<var>key</var>, <var>value</var>)",
                        nil, nil, "ENV[]=",
                        "ENV[]=(key, value)")
    assert_parse_method("ENV[]=(<var>key</var>,<var>value</var>)",
                        nil, nil, "ENV[]=",
                        "ENV[]=(key,value)")
  end

  def test_parse_method_class_method
    assert_parse_method("ENV.clear",
                        "ENV", :class_method, "clear",
                        "ENV.clear")
    assert_parse_method("ENV.store(<var>key</var>,<var>value</var>)",
                        "ENV", :class_method, "store",
                        "ENV.store(key,value)")
    assert_parse_method("ENV.delete(<var>key</var>)",
                        "ENV", :class_method, "delete",
                        "ENV.delete(key)")
    assert_parse_method("ENV.fetch(<var>key</var>,[<var>default</var>])",
                        "ENV", :class_method, "fetch",
                        "ENV.fetch(key,[default])")
    assert_parse_method("ENV.values_at(<var>key_1</var>, ..., <var>key_n</var>)",
                        "ENV", :class_method, "values_at",
                        "ENV.values_at(key_1, ..., key_n)")
  end

  def test_parse_method_instance_method
    assert_parse_method("clear", nil, nil, "clear", "clear")
    assert_parse_method("store(<var>key</var>,<var>value</var>)",
                        nil, nil, "store",
                        "store(key,value)")
    assert_parse_method("delete(<var>key</var>)",
                        nil, nil, "delete",
                        "delete(key)")
    assert_parse_method("fetch(<var>key</var>,[<var>default</var>])",
                        nil, nil, "fetch",
                        "fetch(key,[default])")
    assert_parse_method("values_at(<var>key_1</var>, ..., <var>key_n</var>)",
                        nil, nil, "values_at",
                        "values_at(key_1, ..., key_n)")
  end

  def test_parse_method_setter
    assert_parse_method("default=value",
                        nil, nil, "default=value",
                        "default=value")
    assert_parse_method("default=(<var>value</var>)",
                        nil, nil, "default=",
                        "default=(value)")
  end

  def test_parse_method_ruby_list_24445
    # see http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-list/24445
    assert_parse_method("Class.method(<var>arg1</var>, <var>arg2</var>)",
                        "Class", :class_method, "method",
                        "Class.method(arg1, arg2)")
    assert_parse_method("Class#method(<var>arg1</var>, <var>arg2</var>)",
                        "Class", :instance_method, "method",
                        "Class#method(arg1, arg2)")
    assert_parse_method("Module::Class#method",
                        "Module::Class", :instance_method, "method",
                        "Module::Class#method")
    assert_parse_method("Class::CONSTANT",
                        "Class", :constant, "CONSTANT",
                        "Class::CONSTANT")
    assert_parse_method("method()",
                        "function", :function, "method",
                        "function#method()")

    assert_parse_method("Class#method(<var>arg</var>)",
                        "Class", :instance_method, "method",
                        "Class#method(arg)")
    assert_parse_method("Class#method {|<var>a</var>, <var>b</var>| ... }",
                        "Class", :instance_method, "method",
                        "Class#method {|a, b| ... }")
    assert_parse_method("Class#method(<var>arg1</var>, <var>arg2</var>=<var>nil</var>)",
                        "Class", :instance_method, "method",
                        "Class#method(arg1, arg2=nil)")
    assert_parse_method("Class#method(<var>arg1</var>[, <var>arg2</var>])",
                        "Class", :instance_method, "method",
                        "Class#method(arg1[, arg2])")
    assert_parse_method("Class#method(<var>arg1</var>[, *<var>arg2</var>])",
                        "Class", :instance_method, "method",
                        "Class#method(arg1[, *arg2])")
    assert_parse_method("Class#method(<var>arg1</var>[, ...])",
                        "Class", :instance_method, "method",
                        "Class#method(arg1[, ...])")
    assert_parse_method("Class#[<var>arg</var>]",
                        "Class", :instance_method, "[]",
                        "Class#[](arg)")
    assert_parse_method("Class#[<var>arg1</var>] = <var>arg2</var>",
                        "Class", :instance_method, "[]=",
                        "Class#[]=(arg1, arg2)")
    assert_parse_method("Class.[<var>arg</var>]",
                        "Class", :class_method, "[]",
                        "Class.[](arg)")
    assert_parse_method("Class#+@",
                        "Class", :instance_method, "+@",
                        "Class#+@")
    assert_parse_method("Class#+ <var>arg</var>",
                        "Class", :instance_method, "+",
                        "Class#+ arg")
  end
end
