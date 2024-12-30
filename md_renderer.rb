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
    " │ #{str}\n └#{downline}"
  # H1 ################################
  elsif stripped.start_with? '#'
    upline = '┌─' + ('─' * str.size) + '─┐'
    downline = '└─' + ('─' * str.size) + '─┘'
    side = '│'
    str = render_txt(str, BOLD)
    " #{upline}\n #{side} #{str} #{side}\n #{downline}"
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

# BLOCK STYLES ################################################################

# LINE STYLES #################################################################

formatted_note = raw_note.lines[10..32].map do |line|
  # TITLE
  line = if line.strip.start_with? '#'     then render_title(line.chomp)
  elsif line.strip.start_with? '>'  then render_blockquote(line)
  else render_oneline_styles(line)
  end
  "#{TAB}#{line}"
end

puts formatted_note
