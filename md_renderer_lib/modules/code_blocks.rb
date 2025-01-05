require_relative "styles"

module CodeBlocks
  include Styles

  def codeblock(lang, content) = render_codeblock(lang, content)

  def codeblock_separator(width: TERM_WIDTH, lang: nil)
    return render_txt("▀" * width, CODE_COL) if lang.nil?

    # lang = "code" if lang.empty?
    right = lang.empty? ? "" : " #{lang} "
    left = "▄" * (width - right.size)
    "#{render_txt(left, CODE_COL)}#{render_txt(right, RGB_GRAY)}"
  end

  def render_codeblock(lang, content)
    content = content.gsub('"', %(\\")).gsub("`", %(\\\\`)).chomp
    lang_opt = lang.empty? ? "" : "-l #{lang}"
    bat_opts = "-fP --style=snip --theme='Visual Studio Dark+' #{lang_opt}"

    upline = codeblock_separator(lang:)
    downline = codeblock_separator
    code = `bat #{bat_opts} <<< "#{content}"`.chomp

    bgcol = esc_seq_from(CODE_BG)
    opts = {
      bg_color: {seq: bgcol, fill: true},
      pad_x: 1,
      keep_indent: true
    }
    code = to_lines_with_style(code, **opts).join("\n")

    "#{upline}\n#{code}\n#{downline}"
  end
end
