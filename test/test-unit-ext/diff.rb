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

      def matching_blocks
        queue = [[0, @from.size - 1, 0, @to.size - 1]]
        blocks = []
        until queue.empty?
          from_start, from_end, to_start, to_end = queue.pop
          match_info = longest_match(from_start, from_end, to_start, to_end)
          match_from_index, match_to_index, size = match_info
          unless size.zero?
            blocks << match_info
            if from_start < match_from_index and to_start < match_to_index
              queue.push([from_start, match_from_index,
                          to_start, match_to_index])
            end
            if match_from_index + size < from_end and
                match_to_index + size < to_end
              queue.push([match_from_index + size, from_end,
                          match_to_index + size, to_end])
            end
          end
        end

        non_adjacent = []
        prev_from_index = prev_to_index = prev_size = 0
        blocks.sort.each do |from_index, to_index, size|
          if prev_from_index + prev_size == from_index and
              prev_to_index + prev_size == to_index
            prev_size += size
          else
            unless prev_size.zero?
              non_adjacent << [prev_from_index, prev_to_index, prev_size]
            end
            prev_from_index, prev_to_index, prev_size =
              from_index, to_index, size
          end
        end
        unless prev_size.zero?
          non_adjacent << [prev_from_index, prev_to_index, prev_size]
        end

        non_adjacent << [@from.size, @to.size, 0]
        non_adjacent
      end

      def operations
        from_index = to_index = 0
        operations = []
        matching_blocks.each do |match_from_index, match_to_index, size|
          tag = nil
          if from_index < match_from_index and to_index < match_to_index
            tag = :replace
          elsif from_index < match_from_index
            tag = :delete
          elsif to_index < match_to_index
            tag = :insert
          end

          if tag
            operations << [tag,
                           from_index, match_from_index,
                           to_index, match_to_index]
          end

          from_index, to_index = match_from_index + size, match_to_index + size
          if size > 0
            operations << [:equal,
                           match_from_index, from_index,
                           match_to_index, to_index]
          end
        end

        operations
      end

      private
      def update_to_indexes
        @to_indexes = {}
        each = @to.is_a?(String) ? :each_byte : :each
        i = 0
        @to.send(each) do |item|
          @to_indexes[item] ||= []
          @to_indexes[item] << i
          i += 1
        end
      end
    end

    class Differ
      def initialize(from, to)
        @from = from
        @to = to
      end

      def compare
        result = []
        matcher = SequenceMatcher.new(@from, @to)
        matcher.operations.each do |args|
          tag, from_start, from_end, to_start, to_end = args
          case tag
          when :replace
            result.concat(fancy_replace(from_start, from_end, to_start, to_end))
          when :delete
            result.concat(tagging('-', @from[from_start..from_end]))
          when :insert
            result.concat(tagging('+', @to[to_start..to_end]))
          when :equal
            result.concat(tagging(' ', @from[from_start..from_end]))
          else
            raise "unknown tag: #{tag}"
          end
        end
        result
      end

      private
      def tagging(tag, contents)
        contents.collect {|content| "#{tag} #{content}"}
      end

      def format_diff_point(from_line, to_line, from_tags, to_tags)
        common = [n_leading_characters(from_line, ?\t),
                  n_leading_characters(to_line, ?\t)].min
        common = [common, n_leading_characters(from_tags[0, common], " "[0])].min
        from_tags = from_tags[common..-1].rstrip
        to_tags = to_tags[common..-1].rstrip

        result = ["- #{from_line}"]
        result << "? #{"\t" * common}#{from_tags}" unless from_tags.empty?
        result << "+ #{to_line}"
        result << "? #{"\t" * common}#{to_tags}" unless to_tags.empty?
        result
      end

      def n_leading_characters(string, character)
        n = 0
        while string[n] == character
          n += 1
        end
        n
      end
    end

    module_function
    def ndiff(from, to)
      Differ.new(from, to).compare.join("\n")
    end
  end
end