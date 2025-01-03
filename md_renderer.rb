require_relative 'md_renderer_lib/renderer'

class MdDoc

  
  def initialize(filepath, renderer)
    @rdr = renderer
    @filepath = filepath
    @raw = File.read(filepath)
    @last_modified = File.mtime(filepath).strftime("%Y-%m-%d %H:%M")
    @blocks = []
    make_blocks
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

  def title_block(str)  = { type: :title, content: @rdr.title(str.strip.squeeze(' ')) }
  def separator_block   = { type: :separator, content: @rdr.separator }
  def paragraph_block(str) = { type: :paragraph, content: @rdr.paragraph(str) }
  def table_block(str) = { type: :paragraph, content: @rdr.table(str) }
  def code_block(**data) = { type: :code_block, content: @rdr.code_block(**data) }
  def unord_list_block(str) = { type: :paragraph, content: @rdr.unordered_list(str) }

  # Splits raw markdown file at 2 or more newlines
  # return an array of hashes representing blocks with keys :title & :content
  def make_blocks
    title_regex = /\A\#{1,6} .+\Z/
    separator_regex = /\A(\-|\*){3,}\Z/
    table_regex = /^\s{0,3}((?:\|[^|\n]*\n?)+)/
    codeblock_regex = /(?:```(?<lang>[^\n]*?)\n(?<content>(.|\n)*?)```)/
    unord_list_regex = /((?:\s*- .*(?:\n.+)*(?:\n+|$))+)/

    pp divs = @raw.split(/#{unord_list_regex}|(```(?:.|\n)*?```)|(?:\s*?\n){2}/)
    # reject divs with only empty spaces (or TODO: get a better regex)
    divs.reject! { |div| div.match?(/\A\s*\Z/) }

    divs.each do |str|
      # TODO: recursively split into blocks if needed (if dirty markdown style)
      # split = str.split("\n")
        # Isolate titles
        # Isolate code blocks (start with 4 spaces or ```)

      block = case str
      when unord_list_regex then unord_list_block(str)
      when codeblock_regex  then code_block(lang: $1, content: $2)
      when title_regex      then title_block(str)
      when separator_regex  then separator_block
      when table_regex      then table_block(str)
      else paragraph_block(str)
      end

      @blocks << block
    end
  end
end

md_doc = MdDoc.new(ARGV.first, Renderer.new)

puts md_doc.render
