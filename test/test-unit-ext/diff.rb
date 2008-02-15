# port of ndiff in Python's difflib.

module Test
  module Diff
    class SequenceMatcher
      def initialize(from, to)
        @from = from
        @to = to
        update_to_indexes
      end

      def longest_match(from_start, from_end, to_start, to_end)
        best_from, best_to, best_size = from_start, to_start, 0
        lengths = {}
        from_start.upto(from_end) do |i|
          new_lengths = {}
          (@to_indexes[@from[i]] || []).each do |j|
            next if j < to_start
            break if j >= to_end
            k = new_lengths[j] = (lengths[j - 1] || 0) + 1
            if k > best_size
              best_from, best_to, best_size = i - k + 1, j - k + 1, k
            end
          end
          lengths = new_lengths
        end

        while best_from > from_start and best_to > to_start and
            @from[best_from - 1] == @to[best_to - 1]
          best_from -= 1
          best_to -= 1
          best_size += 1
        end

        while best_from + best_size <= from_end and
            best_to + best_size <= to_end and
            @from[best_from + best_size] == @to[best_to + best_size]
          best_size += 1
        end

        [best_from, best_to, best_size]
      end

      private
      def update_to_indexes
        @to_indexes = {}
        @to.each_with_index do |line, i|
          @to_indexes[line] ||= []
          @to_indexes[line] << i
        end
      end
    end

    class Differ
      def initialize(from, to)
        @from = from
        @to = to
      end

      def compare
      end
    end

    module_function
    def ndiff
      Differ.new(from, to).compare
    end
  end
end
