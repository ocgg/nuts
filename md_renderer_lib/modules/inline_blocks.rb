require_relative "styles"

module InlineBlocks
  include Styles

  def regex_for_inline_block(*syms)
    regs = syms.map do |sym|
      open = sym.gsub(/./) { |char| "\\#{char}" }
      close = sym.reverse.gsub(/./) { |char| "\\#{char}" }
      /(?:\w#{open}\w|\W#{open}\w|\W#{open}\W).*?(?:\w#{close}\w|\w#{close}\W|\W#{close}\W|(?:\w|\W)#{close}$)/
    end
    /(#{regs.join("|")})/
  end

  def inline_block(str, syms, *styles)
    regexp = regex_for_inline_block(*syms)
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

  def bold_italic(str) = inline_block(str, ["***", "**_", "_**", "__*", "___"], BOLD, ITALIC)

  def bold(str) = inline_block(str, ["**", "__"], BOLD)

  def stroke(str) = inline_block(str, ["~~"], STRIKE)

  def italic(str) = inline_block(str, ["*", "_"], ITALIC)

  def inline_codeblock(str) = inline_block(str, ["`"], RGB_BG_DARKGRAY)

  def render_inline_blocks(str)
    str = bold_italic(str)
    str = bold(str)
    str = stroke(str)
    str = italic(str)
    inline_codeblock(str)
  end
end
