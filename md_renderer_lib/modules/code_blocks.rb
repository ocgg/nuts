require_relative 'styles'

module CodeBlocks
  include Styles

  def code_block_separator(lang = nil)
    return render_txt("─" * TERM_WIDTH, RGB_DARKGRAY) if lang.nil?

    lang = 'code' if lang.empty?
    left = "── #{lang} "
    right = "─" * (TERM_WIDTH - left.size)
    render_txt(left + right, RGB_DARKGRAY)
  end

  def render_code_block(**data) 
    content = data[:content].strip.gsub('"', '\"')
    lang = data[:lang]
    lang_opt = lang.empty? ? '' : "-l #{lang}"
    bat_opts = "-fP --style=snip --theme='Visual Studio Dark+' #{lang_opt}"

    upline = code_block_separator(lang)
    downline = code_block_separator
    code = `bat #{bat_opts} <<< "#{content}"`.chomp

    "#{upline}\n#{code}\n#{downline}"
  end
end
