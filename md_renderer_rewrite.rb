class MdDoc
  # TODO: put these in a module
  BOLD = 1
  DIM = 2
  UNDERLINE = 4
  RGB_GRAY = [38,2,150,150,150]
  NOCOLOR = "\e[0m"

  TERM_WIDTH = `tput cols`.to_i > 80 ? 80 : `tput cols`.to_i

  def initialize(filepath)
    @filepath = filepath
    @raw = File.read(filepath)
    @last_modified = File.mtime(filepath).strftime("%Y-%m-%d %H:%M")
    @blocks = make_blocks
  end

  def render
    @blocks.each do |block|
      puts "#{block[:content]}\n\n"
    end
    statline = "#{@filepath} (#{@last_modified})"
    puts render_txt(statline.rjust(TERM_WIDTH), RGB_GRAY)
  end

  private

  def render_txt(str, *styles) = "\e[#{styles.join(';')}m" + str + NOCOLOR

  def render_title(str)
    title = str.gsub(/^#+\s/, '')
    if    str.start_with?('######') then render_txt(title, DIM)
    elsif str.start_with?('#####')  then render_txt(title, BOLD, DIM)
    elsif str.start_with?('####')   then render_txt(title, UNDERLINE)
    elsif str.start_with?('###')    then render_txt(title, BOLD, UNDERLINE)
    elsif str.start_with?('##')
      downline = render_txt('─' * TERM_WIDTH, RGB_GRAY)
      str = render_txt(title, BOLD)
      "#{str}\n#{downline}"
    else
      line = '─' * (TERM_WIDTH - 2)
      upline = render_txt("┌#{line}┐", RGB_GRAY)
      downline = render_txt("└#{line}┘", RGB_GRAY)
      side = render_txt('│', RGB_GRAY)
      str = render_txt(title.center(TERM_WIDTH - 2), BOLD)
      "#{upline}\n#{side}#{str}#{side}\n#{downline}"
    end
  end

  # Splits raw markdown file at 2 or more newlines
  # return an array of hashes representing blocks with keys :title & :content
  def make_blocks
    blocks = []
    @raw.split(/(?:\s*\n){2}/) do |str|
      # TODO: Split into blocks if needed
      # split = str.split("\n")
        # Isolate titles
        # Isolate code blocks (start with 4 spaces or ```)

      # get rid of trailing whitespaces & newlines unless its a code block
      str.strip! unless str.start_with?('    ')

      # TITLE
      if str.match?(/\A\#{1,6} .+\Z/)
        str.squeeze!(' ')
        blocks << { type: :title, content: render_title(str) }
      # CODEBLOCK
          # starts with 4 spaces
          # between ```
        # Empty H1 or H2 ? (prints an thin underline separator on github)
      else
        blocks << { type: :unknown, content: str}
      end
    end
    blocks
  end
end

md_doc = MdDoc.new(ARGV.first)

md_doc.render
