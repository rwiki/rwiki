# -*- indent-tabs-mode: nil -*-

require "time"
require 'rwiki/rw-lib'
require 'rwiki/gettext'
require 'rwiki/pagemodule'
require 'rwiki/navi'
require 'rwiki/diff-utils'

module RWiki
  Version.regist('rwiki/annotate', '$Id$')

  class AnnotateFormat < NaviFormat
    include DiffLink

    @rhtml = {:view => ERBLoader.new('view(pg)', 'annotate.rhtml')}
    reload_rhtml

    private
    def format_annotate(annotate, logs)
      revision_table = {}
      logs.each_with_index do |log, i|
        revision_table[log.revision] = i
      end

      max_author_name_length = 0
      max_revision = 0
      annotate.each do |line|
        max_author_name_length =
          [max_author_name_length, line.author.length].max
        max_revision = [max_revision, revision_table[line.revision]].max
      end

      line_number_of_places = number_of_places(annotate.size)
      revision_number_of_places = number_of_places(max_revision)
      annotate.collect do |line|
        formatted_line = format_line(annotate, line, revision_table,
                                     line_number_of_places,
                                     revision_number_of_places,
                                     max_author_name_length)
        "<span class=\"annotate-line\">#{formatted_line}</span>"
      end.join("\n")
    end

    def format_line(annotate, line, revision_table, line_number_of_places,
                    max_revision_length, max_author_name_length)
      result = no(annotate, line, line_number_of_places)
      result << ": "
      if line.author or line.revision
        result << author(annotate, line, max_author_name_length)
        if line.author and line.revision
          result << " "
        end
        result << revision(annotate, line, revision_table, max_revision_length)
        result << ": "
      end
      result << content(annotate, revision_table, line)
      result
    end

    def no(annotate, line, line_number_of_places)
      formatted_no = "%#{line_number_of_places}d" % line.no
      "<span class=\"annotate-no\">#{h formatted_no}</span>"
    end

    def revision(annotate, line, revision_table, revision_number_of_places)
      rev = revision_table[line.revision]
      space = " " * (revision_number_of_places - number_of_places(rev))
      href = diff_href(target, rev - 1, rev)
      title = "#{h rev} (#{line.date.iso8601})"
      formatted_revision = "<a href=\"#{href}\" title=\"#{title}\">#{h rev}</a>"
      "<span class=\"annotate-revision\">[#{space}#{formatted_revision}]</span>"
    end

    def author(annotate, line, max_author_name_length)
      formatted_author = "%#{max_author_name_length}s" % line.author
      "<span class=\"annotate-author\">#{h formatted_author}</span>"
    end

    def content(annotate, revision_table, line)
      new_num = revision_table.size - revision_table[line.revision] - 1
      class_name = "annotate-content-new#{new_num}"
      content = "<span class=\"annotate-content\">#{h line.content}</span>"
      "<span class=\"#{class_name}\">#{content}</span>"
    end

    def number_of_places(number)
      if number.zero?
        1
      else
        (Math.log10(number) + 1).truncate
      end
    end
  end

  install_page_module('annotate', AnnotateFormat, s_("navi|annotate"))
end
