class TestExtDiff < Test::Unit::TestCase
  def test_to_indexes
    assert_to_indexes({"abc def" => [0, 2], "abc" => [1]},
                      ["abc def", "abc", "abc def"])
  end

  def test_longest_match
    assert_longest_match([0, 1, 3],
                         %w(b c d), %w(a b c d x y z),
                         0, 2, 0, 7)
    assert_longest_match([1, 2, 2],
                         %w(b c d), %w(a b c d x y z),
                         1, 2, 0, 6)
    assert_longest_match([0, 0, 0],
                         %w(a b), %w(c),
                         0, 1, 0, 0)
  end

  def test_same_contents
    # assert_ndiff(["  aaa"], ["aaa"], ["aaa"])
  end

  private
  def assert_to_indexes(expected, to)
    matcher = Test::Diff::SequenceMatcher.new([""], to)
    assert_equal(expected, matcher.instance_variable_get("@to_indexes"))
  end

  def assert_longest_match(expected, from, to,
                           from_start, from_end,
                           to_start, to_end)
    matcher = Test::Diff::SequenceMatcher.new(from, to)
    assert_equal(expected, matcher.longest_match(from_start, from_end,
                                                 to_start, to_end))
  end

  def assert_ndiff(expected, from, to)
    assert_equal(expected, Test::Diff.ndiff(from, to))
  end
end
