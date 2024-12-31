require 'tty-table'

raw_note = File.read(ARGV.first)

NOCOLOR = "\e[0m"
TAB = '  '

# COLORS
BLACK = 30
RED = 31
GREEN = 32
YELLOW = 33
BLUE = 34
PURPLE = 35
CYAN = 36
GRAY = 37

# BG COLORS
BG_BLACK = 40
BG_RED = 41
BG_GREEN = 42
BG_YELLOW = 43
BG_BLUE = 44
BG_PURPLE = 45
BG_CYAN = 46
BG_GRAY = 47

# DECORATION
BOLD = 1
DIM = 2
ITALIC = 3
UNDERLINE = 4
REVERSE = 7
STRIKE = 9

def render_txt(str, *styles) = "\e[#{styles.join(';')}m" + str + NOCOLOR

def render_txt_nosuffix(str, *styles) = "\e[#{styles.join(';')}m" + str

def render_link(txt, url) = "\e]8;;#{url}\e\\#{txt}\e]8;;\e\\"

def render_title(str)
  stripped = str.strip
  str.gsub!(/^\s*(#+)\s/, '')

  # H6 ################################
  if stripped.start_with? '######'
    str = render_txt(str, DIM)
    "#{TAB}#{str}"
  # H5 ################################
  elsif stripped.start_with? '#####'
    str = render_txt(str, BOLD, DIM)
    "#{TAB}#{str}"
  # H4 ################################
  elsif stripped.start_with? '####'
    str = render_txt(str, UNDERLINE)
    "#{TAB}#{str}"
  # H3 ################################
  elsif stripped.start_with? '###'
    str = render_txt(str, BOLD, UNDERLINE)
    "#{TAB}#{str}"
  # H2 ################################
  elsif stripped.start_with? '##'
    downline = '─' * (str.size + 2)
    str = render_txt(str, BOLD)
    " │ #{str}\n #{TAB}└#{downline}"
  # H1 ################################
  elsif stripped.start_with? '#'
    upline = '┌─' + ('─' * str.size) + '─┐'
    downline = TAB + '└─' + ('─' * str.size) + '─┘'
    lside = "#{TAB}│"
    rside = '│'
    str = render_txt(str, BOLD)
    " #{upline}\n #{lside} #{str} #{rside}\n #{downline}"
  end
end

def render_oneline_styles(str)
  bold_pattern = /(?:\*\*|__)(?<bold>[^*]+)(?:\*\*|__)/
  italic_pattern = /(?:\*|_)(?<italic>[^_]+)(?:\*|_)/
  strike_pattern = /(?:\~\~)(?<strike>[^~]+)(?:\~\~)/
  link_pattern = /(?<all>\[(?<txt>[^\]]*)\]\((?<url>[^\)]*)\))/

  str.gsub!(bold_pattern, render_txt('\k<bold>', BOLD))
  str.gsub!(italic_pattern, render_txt('\k<italic>', ITALIC))
  str.gsub!(strike_pattern, render_txt('\k<strike>', STRIKE))
  links = str.scan(link_pattern)
  links.each { |all, txt, url| str.gsub!(all, render_link(txt, url)) }
  str
end

def render_blockquote(str)
  left = str.gsub(/^(>\s?)*/).first.gsub(/>/, '┃')
  str.gsub!(/^(>\s?)*/, '')
  "#{TAB * 2}#{left}#{render_oneline_styles(str)}"
end

# TABLES ######################################################################

def render_table(raw)
  arr = raw.split("\n").map {|row| row.split('|').map(&:strip).reject(&:empty?)}
  header_line_indexes =  arr.map.with_index { |row, i| row.join.match(/:?-+:?/) && i }.compact
  alignments = header_line_indexes.reverse.map { |i| arr.delete_at(i) }.flatten
  alignments.map! do |s|
    if s.start_with?(':') && s.end_with?(':') then :center
    elsif s.end_with?(':') then :right
    else :left
    end
  end

  def separator_indexes_from(header_lines)
    if header_lines.index(0)
      header_lines.select(&:positive?).map.with_index { |o, i| o - (i+2) }
    else
      header_lines.map.with_index { |o, i| o - (i+1) }
    end
  end

  table = TTY::Table.new(header: arr[0], rows: arr[1..])
  table_options = {
    alignments:,
    multiline: true,
    resize: true,
    padding: [0, 1, 0, 1],
    width: 80,
    border: {
      separator: separator_indexes_from(header_line_indexes)
    }
    # column_widths: [nil, 20, 10, 40, 20]
  }

  table.render(:unicode, table_options)
end

tables = raw_note.scan(/^\s*((?:\|[^|\n]*\n?)+)/).flatten
tables.each do |table|
  rendered = render_table(table)
  raw_note.gsub!(table, rendered)
end

# CODE BLOCKS #################################################################

def render_codeblock(lang, content)
  `echo "#{content}" | /usr/bin/bat -n --theme="Visual Studio Dark+" -l #{lang}`
end

codeblocks = raw_note.scan(/(?<all>```(?<lang>\w*)?(?<content>(.|\n)*?)```)/)
codeblocks.each_with_index do |(all, lang, content), i|
  id = "#@!OCGGNUTSCODEBLOCK-#{i}"
  raw_note.gsub!(all, id)
end

# LINE STYLES #################################################################

formatted_note = raw_note.lines.map do |line|
  next line if line.start_with?("#@!OCGGNUTSCODEBLOCK-")
  line =  if line.strip.start_with? '#'     then render_title(line.chomp)
          elsif line.strip.start_with? '>'  then render_blockquote(line)
          else render_oneline_styles(line)
          end
  "#{TAB}#{line}"
end.join

codeblocks.each_with_index do |(all, lang, content), i|
  id = "#@!OCGGNUTSCODEBLOCK-#{i}"
  formatted_note.gsub!(id, render_codeblock(lang, content))
end

puts formatted_note
