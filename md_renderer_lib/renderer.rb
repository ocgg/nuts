require_relative 'modules/styles'
require_relative 'modules/titles'

class Renderer
  include Styles
  include Titles

  def title(str)
    if    str.start_with?('###### ')  then h6(str)
    elsif str.start_with?('##### ')   then h5(str)
    elsif str.start_with?('#### ')    then h4(str)
    elsif str.start_with?('### ')     then h3(str)
    elsif str.start_with?('## ')      then h2(str)
    elsif str.start_with?('# ')       then h1(str)
    end
  end

  def paragraph(str)
    str = str.strip.gsub(/\n/, ' ').squeeze(' ')
    str = render_inline_styles(str)
    str = to_lines(str, TERM_WIDTH).join("\n")
  end

  def separator
    render_txt('━' * TERM_WIDTH, RGB_GRAY)
  end

  def statline(filepath, last_modified)
    statline = "#{filepath} (#{last_modified})"
    render_txt(statline.rjust(TERM_WIDTH), RGB_GRAY)
  end

  private

  def render_txt(str, *styles)
    "\e[#{styles.join(';')}m" + str + NOCOLOR
  end

  def to_lines(str, width=TERM_WIDTH, word_wrap = true)
    # Check if there are escaping sequences and adapt width
    esc_seqs = str.scan(/\e\[[\d;]*m/)
    esc_seqs_width = esc_seqs.join.size
    width = TERM_WIDTH + esc_seqs_width

    if word_wrap
      str.scan(/\S.{0,#{width-2}}\S(?=\s|$)|\S+/)
    else
      str.chars.each_slice(width).map(&:join)
    end
  end

  def regex_for_inline_style(*syms)
    regs = syms.map do |sym|
      open = sym.gsub(/./) { |char| "\\" + char }
      close = sym.reverse.gsub(/./) { |char| "\\" + char }
      /(?:\w#{open}\w|\W#{open}\w|\W#{open}\W).*?(?:\w#{close}\w|\w#{close}\W|\W#{close}\W|(?:\w|\W)#{close}$)/
    end
    /(#{regs.join('|')})/
  end

  def inline_style(str, syms, *styles)
    regexp = regex_for_inline_style(*syms)
    spans = str.scan(regexp).flatten

    spans.each do |span|
      signs = syms.join.chars.uniq
      sym_length = syms.first.length
      # The regex captures trailing char each side, except right if its $.
      # 1 is for the trailing char, sym_length for the sign
      span = span[1..(signs.include?(span[-1]) ? -1 : -2)]
      text = span[sym_length...-sym_length]

      str.gsub!(span, render_txt(text, *styles))
    end
    str
  end

  def bold_italic(str) = inline_style(str, ["***", "**_", "_**", "__*", "___"], BOLD, ITALIC)
  def bold(str) = inline_style(str, ["**", "__"], BOLD)
  def stroke(str) = inline_style(str, ["~~"], STRIKE)
  def italic(str) = inline_style(str, ["*", "_"], ITALIC)
  def inline_codeblock(str) = inline_style(str, ["`"], REVERSE)

  def render_inline_styles(str)
    str = bold_italic(str)
    str = bold(str)
    str = stroke(str)
    str = italic(str)
    str = inline_codeblock(str)
    str
  end
end
