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
    str = render_inline_styles(str)
    to_lines(str, TERM_WIDTH).join("\n")
  end

  def separator
    render_txt('━' * TERM_WIDTH, RGB_GRAY)
  end

  def table(str)
    render_table(str)
  end
  
  def code_block(**data)
    render_code_block(**data)
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
end
