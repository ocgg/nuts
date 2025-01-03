require_relative 'styles'

module Lists
  include Styles

  def render_unordered_list(str)
    arr = str.strip.squeeze("\n").split("\n")
    clean_str = arr.reduce('') do |acc, s|
      next s if acc.empty?

      stripped = s.strip
      stripped.match?(/^- /) ? "#{acc}\n#{s}" : "#{acc} #{stripped}"
    end
    # TODO: round here: manage list hierarchy
    clean_str = render_inline_blocks(clean_str)
    to_lines_with_style(clean_str).join("\n")
  end
end
