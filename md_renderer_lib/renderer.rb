require_relative 'modules/styles'
require_relative 'modules/titles'
require_relative 'modules/inline_blocks'
require_relative 'modules/tables'
require_relative 'modules/code_blocks'

class Renderer
  include Styles
  include Titles
  include InlineBlocks
  include Tables
  include CodeBlocks

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
    str = render_inline_blocks(str)
    to_lines_with_style(str, TERM_WIDTH).join("\n")
  end

  def separator
    render_txt('━' * TERM_WIDTH, RGB_GRAY)
  end

  def table(str)
    render_table(str)
  end
  
  def code_block(**data)
    render_codeblock(**data)
  end

  def statline(filepath, last_modified)
    statline = "#{filepath} (#{last_modified})"
    render_txt(statline.rjust(TERM_WIDTH), RGB_GRAY)
  end

  private

  def render_txt(str, *styles)
    "\e[#{styles.join(';')}m" + str + NOCOLOR
  end

  def to_lines(str, width=TERM_WIDTH, word_wrap=true)
    if word_wrap
      str.scan(/\S.{0,#{width-2}}\S(?=\s|$)|\S+/)
    else
      str.chars.each_slice(width).map(&:join)
    end
  end

  # TODO: Like to_lines, but manage escape sequences
  def to_lines_with_style(str, width=TERM_WIDTH, word_wrap = true)
    chunks = str.split(/(\e\[[\d;]*m)/)

    seq_stack = []
    count = 0
    line = ""
    lines = []

    chunks.each do |chunk|
      next if chunk.empty?
      is_reset = chunk.match?(/\e\[0m/)
      is_seq = chunk.match?(/\e\[[\d;]*m/)

      seq_stack << chunk if is_seq
      seq_stack = [] if is_reset
      next line += chunk if is_seq || is_reset

      chunk.each_char do |char|
        if count == width || char == "\n"
          line += "\e\[0m"  # Reset styles (because one day: columns!)
          lines << line
          line = seq_stack.reverse.join # Start new line with undergoing style
          count = 0
        end
        line += char unless char == "\n" || count == 0 && char == ' '
        count += 1
      end
    end

    line += "\e\[0m"
    lines << line

    lines
  end
end
