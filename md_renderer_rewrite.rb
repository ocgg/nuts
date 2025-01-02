require_relative 'md_renderer_lib/modules/styles'
require_relative 'md_renderer_lib/renderer'

class MdDoc
  include Styles

  TERM_WIDTH = `tput cols`.to_i > 80 ? 80 : `tput cols`.to_i

  def initialize(filepath, renderer)
    @rdr = renderer
    @filepath = filepath
    @raw = File.read(filepath)
    @last_modified = File.mtime(filepath).strftime("%Y-%m-%d %H:%M")
    @blocks = make_blocks
  end

  def render
    results = @blocks.map do |block|
      "#{block[:content]}\n"
    end
    statline = @rdr.statline(@filepath, @last_modified)
    results << statline
    results.join("\n")
  end

  private

  def render_title(str) = @rdr.title(str.strip.squeeze(' '))
  def render_separator = @rdr.separator
  def render_paragraph(str) = @rdr.paragraph(str)

  # Splits raw markdown file at 2 or more newlines
  # return an array of hashes representing blocks with keys :title & :content
  def make_blocks
    blocks = []
    @raw.split(/(?:\s*\n){2}/) do |str|
      # TODO: Split into blocks if needed (if dirty markdown style)
      # split = str.split("\n")
        # Isolate titles
        # Isolate code blocks (start with 4 spaces or ```)

      if str.match?(/\A\#{1,6} .+\Z/)
        blocks << { type: :title, content: render_title(str) }
      elsif str.match?(/\A(\-|\*){3,}\Z/)
        blocks << { type: :separator, content: render_separator}
      # CODEBLOCK
          # starts with 4 spaces
          # between ```
      else
        blocks << { type: :paragraph, content: render_paragraph(str)}
      end
    end
    blocks
  end
end

md_doc = MdDoc.new(ARGV.first, Renderer.new)

puts md_doc.render
