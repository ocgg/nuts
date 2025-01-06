require "tty-table"
require_relative "styles"

module Tables
  include Styles

  def table(str) = render_table(str)

  private

  def separator_indexes_from(header_lines)
    if header_lines.index(0)
      header_lines.select(&:positive?).map.with_index { |o, i| o - (i + 2) }
    else
      header_lines.map.with_index { |o, i| o - (i + 1) }
    end
  end

  def render_table(str)
    arr = str.split("\n").map { |row| row.split("|").map(&:strip)[1..] }
    header_line_indexes = arr.map.with_index { |row, i| row.join.match(/:?-+:?/) && i }.compact
    alignments = header_line_indexes.reverse.map { |i| arr.delete_at(i) }.flatten
    alignments.map! do |s|
      if s.start_with?(":") && s.end_with?(":") then :center
      elsif s.end_with?(":") then :right
      else
        :left
      end
    end

    table = TTY::Table.new(arr)
    table_options = {
      alignments:,
      multiline: true,
      resize: true,
      padding: [0, 1, 0, 1],
      width: TERM_WIDTH,
      border: {
        separator: separator_indexes_from(header_line_indexes)
      }
      # column_widths: [nil, 20, 10, 40, 20]
    }

    table.render(:unicode, table_options)
  end
end
