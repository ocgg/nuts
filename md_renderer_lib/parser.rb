class Parser
  attr_reader :chunks

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

  def format_list(list)
    list.squeeze("\n").split("\n").reduce("") do |acc, line|
      next line if acc.empty?
      stripped = strip_and_squeeze(line)
      line.match?(/^\s{2,}- /) ? "#{acc}\n#{line}" : "#{acc} #{stripped}"
      stripped.match?(/^- /) ? "#{acc}\n#{line}" : "#{acc} #{stripped}"
      if line.match?(/^- /) then "#{acc}\n#{stripped}"
      elsif line.match?(/^\s{2,}- /) then "#{acc}\n  #{stripped}"
      else
        "#{acc} #{stripped}"
      end
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
    raw.scan(/#{regexs.values.join("|")}/).map do |data|
      # find index of non-nil data
      id = data.find_index { |match| !match.nil? }
      type = types[id]
      content = data[id]
      chunk_from(type, content)
    end
  end
end
