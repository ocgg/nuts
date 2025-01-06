require_relative "styles"

module InlineBlocks
  include Styles

  # This was a good try.
  REGEXP = /
    # prefix
    (?<=(?<beforebegin>\W))?
    # opening tag
    (?<open_tag>\*\*\*|___|\*\*|__|\*|_|`|~~|~)
    # content
    (?<content>
      (?(<beforebegin>).|\w)
      .*?
      (?<beforeend>\w)?
    )
    # closing tag
    (?<close_tag>\k<open_tag>)
    # suffix
    (?=(?(<beforeend>).|\W)|$)
  /x

  def delimiter_to_stylecode(delimiter)
    case delimiter
    when "***", "___" then [BOLD, ITALIC]
    when "**", "__" then BOLD
    when "*", "_" then ITALIC
    when "~~", "~" then STRIKE
    when "`" then Styles::CODE_BG
    # Should never reach this line
    else raise "Unknown delimiter '#{delimiter}'"
    end
  end

  def render_inline_chunks(str, styles = [])
    result = ""
    REGEXP.match str

    match = $3
    return str if match.nil?

    result += $`
    style = delimiter_to_stylecode($2)
    seq = esc_seq_from(style)

    suffix = styles.empty? ? NOCOLOR : "#{NOCOLOR}#{esc_seq_from(styles)}"
    styles << style

    parsed = "#{seq}#{render_inline_chunks(match, styles)}#{suffix}"

    "#{result}#{parsed}#{render_inline_chunks($')}"
  end
end
