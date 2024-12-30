raw_note = File.read(ARGV.first)

NOCOLOR = "\e[0m"

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

def txt_render(str, *styles)
  "\e[#{styles.join(';')}m" + str + NOCOLOR
end
def txt_render_nosuffix(str, *styles) = "\e[#{styles.join(';')}m" + str
# puts txt_render(raw_note, BOLD, YELLOW)

def render_title(str)
  stripped = str.strip
  str.gsub!(/^\s*(#+)\s/, '')

  # H6 ################################
  if stripped.start_with? '######'
    str = txt_render(str, DIM)
    "  #{str}"
  # H5 ################################
  elsif stripped.start_with? '#####'
    str = txt_render(str, BOLD, DIM)
    "  #{str}"
  # H4 ################################
  elsif stripped.start_with? '####'
    str = txt_render(str, UNDERLINE)
    "  #{str}"
  # H3 ################################
  elsif stripped.start_with? '###'
    str = txt_render(str, BOLD, UNDERLINE)
    "  #{str}"
  # H2 ################################
  elsif stripped.start_with? '##'
    downline = '─' * (str.size + 2)
    str = txt_render(str, BOLD)
    " │ #{str}\n └#{downline}"
  # H1 ################################
  elsif stripped.start_with? '#'
    upline = '┌─' + ('─' * str.size) + '─┐'
    downline = '└─' + ('─' * str.size) + '─┘'
    side = '│'
    str = txt_render(str, BOLD)
    " #{upline}\n #{side} #{str} #{side}\n #{downline}"
  end
end

def render_decorations(str)
  bold_pattern = /(?:\*\*|__)/
  italic_pattern = /(?:\*|_)/
  strike_pattern = /(?:\~\~)/

  str.gsub!(/#{bold_pattern}(?<bold>[^*]+)#{bold_pattern}/, txt_render('\k<bold>', BOLD))
  str.gsub!(/#{italic_pattern}(?<italic>[^_]+)#{italic_pattern}/, txt_render('\k<italic>', ITALIC))
  str.gsub!(/#{strike_pattern}(?<strike>[^~]+)#{strike_pattern}/, txt_render('\k<strike>', STRIKE))

  str
end

def render_blockquote(str)
  left = str.gsub(/^(>\s?)*/).first.gsub!(/>/, '┃')
  str.gsub!(/^(>\s?)*/, '')
  "    #{left}#{render_decorations(str)}"
end

formatted_note = raw_note.lines[18..25].map do |line|
  # TITLE
  if line.strip.start_with? '#'
    render_title(line.chomp)
  elsif line.strip.start_with? '>'
    render_blockquote(line)
  else
    render_decorations(line)
  end
end

puts formatted_note
