class Parser
  attr_reader :chunks

  REGEXS = {
    title: /^\s{0,3}(?<title>\#{1,6} .+)$/,
    separator: /^\s{0,3}(?<separator>[-*]{3,})$/,
    table: /^\s{0,3}(?<table>(?:\|[^|\n]*\n?)+)/,
    # TODO: theses should be simpler
    codeblock: /^\s{0,3}(?<all>```(?<cb_lang>[^\n]*?)\n(?<cb_content>(?:.|\n)*?)```)/,
    unord_list: /^\s{0,3}(?<unord_list>(?:\s*- .*(?:\n.+)*(?:\n+|$))+)/,
    paragraph: /^\s{0,3}(?<paragraph>.*)/
  }

  def initialize(raw)
    @chunks = parse(raw)
  end

  private

  # FORMATING #################################################################

  def format_codeblock(codeblock)
    lang = codeblock.match(/^```(.*)$/)[1]
    code = codeblock.split("\n")[1..-2].join("\n")
    {lang:, code:}
  end

  # Receive a raw string possibly dirty markdown,
  # Ouputs a list string with indented, squeezed, un-newlined lines.
  def format_list(list)
    list.squeeze("\n").split("\n").reduce("") do |acc, line|
      next line if acc.empty?
      next "#{acc} #{strip_and_squeeze(line)}" unless line.match?(/(^\s*- )/)

      indent_level = case line
      when /^\s?- / then 0
      when /^\s{2,3}- / then 1
      when /^(\s{4,})- / then $1.length / 2
      end
      indent = "  " * indent_level

      "#{acc}\n#{indent}#{strip_and_squeeze(line)}"
    end
  end

  def strip_and_squeeze(str)
    str.strip.squeeze(" ").squeeze("\n")
  end

  # PARSING ###################################################################

  def chunk_from(type, content)
    content = case type
    when :codeblock then format_codeblock(content)
    when :unord_list then format_list(content)
    when :title, :separator, :table, :paragraph
      strip_and_squeeze(content)
    else
      content
    end

    {type:, content:}
  end

  # Splits raw markdown file at 2 or more newlines
  # return an array of hashes representing chunks with keys :title & :content
  # TODO: fix time complexity
  def parse(raw)
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
    raw.scan(/#{REGEXS.values.join("|")}/).map do |data|
      # find index of non-nil data
      id = data.find_index { |match| !match.nil? }
      type = types[id]
      content = data[id]
      chunk_from(type, content)
    end
  end
end
