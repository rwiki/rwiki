# port of ndiff in Python's difflib.

module Test
  module Diff
    class SequenceMatcher
      def initialize(from, to)
        @from = from
        @to = to
        update_to_indexes
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
