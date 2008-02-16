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

      def ratio
        matches = matching_blocks.inject(0) {|result, block| result + block[-1]}
        length = @from.length + @to.length
        if length.zero?
          1.0
        else
          2.0 * matches / length
        end
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
            result.concat(diff_lines(from_start, from_end, to_start, to_end))
          when :delete
            result.concat(tagging('-', @from[from_start...from_end]))
          when :insert
            result.concat(tagging('+', @to[to_start...to_end]))
          when :equal
            result.concat(tagging(' ', @from[from_start...from_end]))
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

      def diff_lines(from_start, from_end, to_start, to_end)
        best_ratio, cut_off = 0.74, 0.75
        from_equal_index = to_equal_index = nil
        best_from_index = best_to_index = nil
        to_start.upto(to_end) do |to_index|
          from_start.upto(from_end) do |from_index|
            if @from[from_index] == @to[to_index]
              from_equal_index ||= from_index
              to_equal_index ||= to_index
              next
            end

            matcher = SequenceMatcher.new(@from[from_index], @to[to_index])
            if matcher.ratio > best_ratio
              best_ratio = matcher.ratio
              best_from_index = from_index
              best_to_index = to_index
            end
          end
        end

        if best_ratio < cut_off
          if from_equal_index.nil?
            return
          end
          best_from_index = from_equal_index
          best_to_index = to_equal_index
          best_ratio = 1.0
        else
          from_equal_index = nil
        end

        _diff_lines(from_start, best_from_index, to_start, best_to_index) +
          diff_line(best_from_index, best_to_index) +
          _diff_lines(best_from_index + 1, from_end, best_to_index + 1, to_end)
      end

      def _diff_lines(from_start, from_end, to_start, to_end)
        if from_start < from_end
          if to_start < to_end
            diff_lines(from_start, from_end, to_start, to_end)
          else
            tagging("-", @from[from_start...from_end])
          end
        else
          tagging("+", @to[to_start...to_end])
        end
      end

      def diff_line(from_line, to_line)
        from_tags = ""
        to_tags = ""
        matcher = SequenceMatcher.new(from_line, to_line)
        matcher.operations.each do |tag, from_start, from_end, to_start, to_end|
          from_length = from_end - from_start
          to_length = to_end - to_start
          case tag
          when :replace
            from_tags << "^" * from_length
            to_tags << "^" * to_length
          when :delete
            from_tags << "-" * from_length
          when :insert
            to_tags << "+" * to_length
          when :equal
            from_tags << " " * from_length
            to_tags << " " * to_length
          else
            raise "unknown tag: #{tag}"
          end
        end
        format_diff_point(from_line, to_line, from_tags, to_tags)
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
