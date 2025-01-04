class MdDoc
  def initialize(filepath, renderer)
    @rdr = renderer
    @filepath = filepath
    @raw = File.read(filepath)
    @last_modified = File.mtime(filepath).strftime("%Y-%m-%d %H:%M")
    @chunks = make_chunks
  end

  def formatted_lines
    @chunks.map do |chunk|
      case chunk[:type]
      when :codeblock then chunk[:all].chomp
      when :unord_list then format_list(chunk)
      when :title, :separator, :table, :paragraph
        strip_and_squeeze(chunk[:content])
      else
        chunk[:content]
      end
    end
  end

  def formatted_string = formatted_lines.join("\n\n")

  def render_lines
    @chunks.map do |chunk|
      next @rdr.send(chunk[:type], chunk[:lang], chunk[:content]) if chunk[:type] == :codeblock
      next @rdr.send(chunk[:type]) if chunk[:type] == :separator

      @rdr.send(chunk[:type], chunk[:content])
    end
  end

  def render_string = render_lines.join("\n\n")

  def render_with_status_line
    lines = render_lines

    statline = @rdr.statline(@filepath, @last_modified)
    lines << statline
    lines.join("\n\n")
  end

  private

  def strip_and_squeeze(str)
    str.strip.squeeze(" ").squeeze("\n")
  end

  def format_list(chunk)
    chunk[:content].squeeze("\n").split("\n").reduce("") do |acc, line|
      next line if acc.empty?
      stripped = strip_and_squeeze(line)
      # line.match?(/^\s{2,}- /) ? "#{acc}\n#{line}" : "#{acc} #{stripped}"
      # stripped.match?(/^- /) ? "#{acc}\n#{line}" : "#{acc} #{stripped}"
      if line.match?(/^- /) then "#{acc}\n#{stripped}"
      elsif line.match?(/^\s{2,}- /) then "#{acc}\n  #{stripped}"
      else
        "#{acc} #{stripped}"
      end
    end
  end

  # Splits raw markdown file at 2 or more newlines
  # return an array of hashes representing chunks with keys :title & :content
  def make_chunks
    regexs = {
      title: /^\s{0,3}(?<title>\#{1,6} .+)$/,
      separator: /^\s{0,3}(?<separator>[-*]{3,})$/,
      table: /^\s{0,3}(?<table>(?:\|[^|\n]*\n?)+)/,
      codeblock: /^\s{0,3}(?<all>```(?<cb_lang>[^\n]*?)\n(?<cb_content>(?:.|\n)*?)```)/,
      unord_list: /^\s{0,3}(?<unord_list>(?:\s*- .*(?:\n.+)*(?:\n+|$))+)/,
      paragraph: /^\s{0,3}(?<paragraph>.*)/
    }
    types = [
      :title,
      :separator,
      :table,
      :codeblock, # all
      :codeblock, # lang
      :codeblock, # content
      :unord_list,
      :paragraph
    ]
    @raw.scan(/#{regexs.values.join("|")}/).map do |data|
      # find index of non-nil data
      id = data.find_index { |match| !match.nil? }
      type = types[id]
      content = data[id]
      if type == :codeblock
        {type:, all: data[id], lang: data[id + 1], content: data[id + 2]}
      else
        {type:, content:}
      end
    end
  end
end
