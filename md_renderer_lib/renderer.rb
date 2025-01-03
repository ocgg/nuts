require_relative 'modules/styles'
require_relative 'modules/titles'
require_relative 'modules/inline_blocks'
require_relative 'modules/tables'
require_relative 'modules/code_blocks'
require_relative 'modules/lists'

class Renderer
  include Styles
  include Titles
  include InlineBlocks
  include Tables
  include CodeBlocks
  include Lists

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
    to_lines_with_style(str).join("\n")
  end

  def separator = render_txt('━' * TERM_WIDTH, RGB_GRAY)
  def table(str) = render_table(str)
  def code_block(**data) = render_codeblock(**data)

  def unordered_list(str)
    render_unordered_list(str)
  end

  def statline(filepath, last_modified)
    statline = "#{filepath} (#{last_modified})"
    render_txt(statline.rjust(TERM_WIDTH), RGB_GRAY)
  end

  private

  def esc_seq_from(*styles) = "\e[#{styles.join(';')}m"

  def render_txt(str, *styles)
    "\e[#{styles.join(';')}m" + str + NOCOLOR
  end

  def render_txt_nosuffix(str, *styles) = "\e[#{styles.join(';')}m" + str

  def to_lines(str, width=TERM_WIDTH, word_wrap=true)
    if word_wrap
      str.scan(/\S.{0,#{width-2}}\S(?=\s|$)|\S+/)
    else
      str.chars.each_slice(width).map(&:join)
    end
  end

  # TODO: Like to_lines, but manage escape sequences
  # Possible opts:
  #   { bg_color: { seq: '', fill = true }
  #     seq: escape sequence corresponding to bg style e.g '\e[48;2;0;0;0m'
  #     fill: fill entire term width with bg color if true
  #   }
  def to_lines_with_style(str, **opts)
    chunks = str.split(/(\e\[[\d;]*m)/)

    # TODO: better opts managment
    opts.default = {}
    bg_color = opts[:bg_color]
    bg_seq = bg_color[:seq] || ''
    bg_fill = bg_color[:fill] || true

    width = TERM_WIDTH
    seq_stack = []
    count = 0
    line = bg_seq
    lines = []

    chunks.each do |chunk|
      next if chunk.empty?

      is_reset = chunk.match?(/\e\[0m/)
      is_seq = chunk.match?(/\e\[[\d;]*m/)

      if is_reset
        seq_stack = []
        line += chunk + bg_seq
        next
      elsif is_seq
        seq_stack << chunk 
        line += chunk
        next 
      end

      chunk.each_char do |char|
        if count == width || char == "\n"
          line += ' ' * (width - count) if bg_fill && count < width
          line += "\e\[0m" # Reset styles (because one day: columns!)
          lines << line
          # Start new line with undergoing style & opts styles
          line = seq_stack.reverse.join + bg_seq
          count = 0
        end
        unless char == "\n" || (count == 0 && char == ' ')
          line += char
          count += 1
        end
      end
    end

    line += ' ' * (width - count) if bg_fill && count < width
    line += "\e\[0m"
    lines << line

    lines
  end
end
