require_relative "modules/styles"
require_relative "modules/titles"
require_relative "modules/inline_blocks"
require_relative "modules/tables"
require_relative "modules/code_blocks"
require_relative "modules/lists"

class Renderer
  include Styles
  include Titles
  include InlineBlocks
  include Tables
  include CodeBlocks
  include Lists

  def title(str)
    if str.start_with?("###### ") then h6(str)
    elsif str.start_with?("##### ") then h5(str)
    elsif str.start_with?("#### ") then h4(str)
    elsif str.start_with?("### ") then h3(str)
    elsif str.start_with?("## ") then h2(str)
    elsif str.start_with?("# ") then h1(str)
    end
  end

  def paragraph(str)
    str = str.strip.tr("\n", " ").squeeze(" ")
    str = render_inline_blocks(str)
    to_lines_with_style(str).join("\n")
  end

  def separator = render_txt("━" * TERM_WIDTH, RGB_GRAY)

  def table(str) = render_table(str)

  def codeblock(lang, content) = render_codeblock(lang, content)

  def unord_list(str)
    render_unord_list(str)
  end

  def statline(filepath, last_modified)
    statline = "#{filepath} (#{last_modified})"
    render_txt(statline.rjust(TERM_WIDTH), RGB_GRAY)
  end

  private

  def esc_seq_from(*styles) = "\e[#{styles.join(";")}m"

  def render_txt(str, *styles)
    "\e[#{styles.join(";")}m" + str + NOCOLOR
  end

  def render_txt_nosuffix(str, *styles) = "\e[#{styles.join(";")}m" + str

  def to_lines(str, width = TERM_WIDTH, word_wrap = true)
    if word_wrap
      str.scan(/\S.{0,#{width - 2}}\S(?=\s|$)|\S+/)
    else
      str.chars.each_slice(width).map(&:join)
    end
  end

  # Like to_lines, but ignore escape sequences in string width
  # Possible opts:
  #   {
  #     bg_color: {
  #       seq: "",    # escape sequence corresponding to bg style e.g '\e[48;2;0;0;0m'
  #       fill = true # fill full line width with bg color if true
  #     },
  #     pad_x: 0, # padding value for left & right
  #     pad_y: 0  # padding value fot up & down
  #     code: false # keeps indentation if true
  #   }
  def to_lines_with_style(str, width = TERM_WIDTH, **opts)
    chunks = str.split(/(\e\[[\d;]*m)/)

    # TODO: better opts managment
    bg_color = opts[:bg_color] || {}
    bg_seq = bg_color[:seq] || ""
    bg_fill = bg_color[:fill] || true
    padx = opts[:pad_x] || 0
    pady = opts[:pad_y] || 0
    code = opts[:code] || false

    width -= padx * 2
    lines = []

    seq_stack = []
    count = 0
    # line = bg_seq
    line = bg_seq + (" " * padx)

    pady.positive? && pady.times do
      padline = bg_fill ? line + " " * (width + padx) + NOCOLOR : ""
      lines << padline
    end

    # chunks are either escape sequences, either text strings
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
        # If end of line
        if count == width || char == "\n"
          # fill with bg color
          line += " " * (width - count + padx) if bg_fill
          # Reset styles at end of line (for future columns)
          line += "\e[0m"
          lines << line
          # Reset new line, with undergoing style & opts styles
          line = seq_stack.reverse.join + bg_seq + (" " * padx)
          count = 0
        end
        next if char == "\n"
        unless code
          next if count == 0 && char == " "
        end

        line += char
        count += 1
      end
    end

    line += " " * (width - count + padx) if bg_fill && count < width
    line += "\e[0m"
    lines << line

    pady.positive? && pady.times do
      line = bg_seq + (" " * padx)
      padline = bg_fill ? line + " " * (width + padx) + NOCOLOR : ""
      lines << padline
    end

    lines
  end
end
