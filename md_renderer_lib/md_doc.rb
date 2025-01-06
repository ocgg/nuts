require_relative "renderer"
require_relative "parser"

# This is the entry point and the main controller.
class MdDoc
  def initialize(filepath)
    @filepath = filepath
    @raw = File.read(filepath)
    @last_modified = File.mtime(filepath).strftime("%Y-%m-%d %H:%M")
    @parser = Parser.new(@raw)
    @renderer = Renderer.new
  end

  def formatted_lines
    # TODO: manage codeblocks
    @parser.chunks.map { |c| c[:content] }
  end

  def formatted_string = formatted_lines.join("\n\n")

  def render_lines
    @parser.chunks.map do |chunk|
      if chunk[:type] == :separator
        @renderer.send(chunk[:type])
      else
        @renderer.send(chunk[:type], chunk[:content])
      end
    end
  end

  def render_string = render_lines.join("\n\n")

  def render_with_status_line
    lines = render_lines

    statline = @renderer.statline(@filepath, @last_modified)
    lines << statline
    lines.join("\n\n")
  end
end
