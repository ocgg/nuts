require_relative "styles"

module CodeBlocks
  include Styles

  def codeblock_separator(lang = nil)
    return render_txt("▀" * TERM_WIDTH, CODE_COL) if lang.nil?

    lang = "code" if lang.empty?
    left = "▄▄ #{lang} "
    right = "▄" * (TERM_WIDTH - left.size)
    render_txt(left + right, CODE_COL)
  end

  def render_codeblock(lang, content)
    content = content.gsub('"', '\"').chomp
    lang_opt = lang.empty? ? "" : "-l #{lang}"
    bat_opts = "-fP --style=snip --theme='Visual Studio Dark+' #{lang_opt}"

    upline = codeblock_separator(lang)
    downline = codeblock_separator
    code = `bat #{bat_opts} <<< "#{content}"`.chomp

    bgcol = esc_seq_from(CODE_BG)
    code = to_lines_with_style(code, bg_color: {seq: bgcol, fill: true}).join("\n")

    "#{upline}\n#{code}\n#{downline}"
  end
end
