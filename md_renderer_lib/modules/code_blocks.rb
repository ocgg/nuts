require_relative "styles"

module CodeBlocks
  include Styles

  def codeblock(content) = render_codeblock(content)

  private

  def codeblock_separator(width: TERM_WIDTH, lang: nil)
    return render_txt("▀" * width, CODE_COL) if lang.nil?

    # lang = "code" if lang.empty?
    right = lang.empty? ? "" : " #{lang} "
    left = "▄" * (width - right.size)
    "#{render_txt(left, CODE_COL)}#{render_txt(right, RGB_GRAY)}"
  end

  def render_codeblock(content)
    code = content[:code]
    lang = content[:lang]

    code = code.gsub('"', %(\\")).gsub("`", %(\\\\`)).chomp
    lang_opt = lang.empty? ? "" : "-l #{lang}"
    bat_opts = "-fP --style=snip --theme='Visual Studio Dark+' #{lang_opt}"

    upline = codeblock_separator(lang:)
    downline = codeblock_separator
    processed_code = `bat #{bat_opts} <<< "#{code}"`.chomp

    bgcol = esc_seq_from(CODE_BG)
    opts = {
      bg_color: {seq: bgcol, fill: true},
      pad_x: 1,
      keep_indent: true
    }
    processed_code = to_lines_with_style(processed_code, **opts).join("\n")

    "#{upline}\n#{processed_code}\n#{downline}"
  end
end
