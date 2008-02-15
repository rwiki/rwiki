class TestExtDiff < Test::Unit::TestCase
  def test_to_indexes
    assert_to_indexes({"abc def" => [0, 2], "abc" => [1]},
                      ["abc def", "abc", "abc def"])
  end

  def test_same_contents
    # assert_ndiff(["  aaa"], ["aaa"], ["aaa"])
  end

  private
  def assert_to_indexes(expected, to)
    matcher = Test::Diff::SequenceMatcher.new([""], to)
    assert_equal(expected, matcher.instance_variable_get("@to_indexes"))
  end

  def assert_ndiff(expected, from, to)
    assert_equal(expected, Test::Diff.ndiff(from, to))
  end
end
