require_relative "styles"

module Lists
  include Styles

  def unord_list(str) = render_unord_list(str)

  def render_unord_list(str)
    str = sanitize_list_string(str)
    str = render_inline_blocks(str)
    lines = to_lines_with_style(str, keep_indent: true, word_wrap: true)

    prev_line = ""

    lines.map! do |line|
      line = case line
      when /(^\s?- )/ then line.gsub($1, "• ")
      when /^(\s{2,3}- )/ then line.gsub($1, "  ◦ ")
      when /^(\s{4,})(- )/
        indent_levels = $1.length / 2
        indent = "  " * indent_levels
        line.gsub("#{$1}#{$2}", "#{indent}▪ ")
      else
        indent_levels = prev_line.match(/^\s*/)[0].length / 2
        indent = "  " * (indent_levels + 1)
        "#{indent}#{line}"
      end
      prev_line = line
      "  #{line}"
    end.join("\n")
  end

  private

  def sanitize_list_string(str)
    lines = str.strip.squeeze("\n").split("\n")
    lines.reduce("") do |acc, s|
      next s if acc.empty?

      stripped = s.strip
      stripped.match?(/^- /) ? "#{acc}\n#{s}" : "#{acc} #{stripped}"
    end
  end
end
