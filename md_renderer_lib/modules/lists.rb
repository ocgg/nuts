require_relative "styles"

module Lists
  include Styles

  def unord_list(str) = render_unord_list(str)

  private

  def render_unord_list(str)
    str = render_inline_chunks(str)
    lines = to_lines_with_style(str, keep_indent: true, word_wrap: true)

    prev_line = ""

    pp lines

    # lines.map! do |line|
    #   line = case line
    #   when /(^\s?- )/ then line.gsub($1, "• ")
    #   when /^(\s{2,3}- )/ then line.gsub($1, "  ◦ ")
    #   when /^(\s{4,})(- )/
    #     indent_levels = $1.length / 2
    #     indent = "  " * indent_levels
    #     line.gsub("#{$1}#{$2}", "#{indent}▪ ")
    #   else
    #     indent_levels = prev_line.match(/^\s*/)[0].length / 2
    #     indent = "  " * (indent_levels + 1)
    #     "#{indent}#{line}"
    #   end
    #   prev_line = line
    #   "  #{line}"
    # end.join("\n")
  end
end
