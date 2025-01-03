module Styles
  BOLD = 1
  DIM = 2
  ITALIC = 3
  UNDERLINE = 4
  REVERSE = 7
  STRIKE = 9

  RGB_GRAY = [38,2,150,150,150]
  RGB_DARKGRAY = [38,2,110,110,110]
  NOCOLOR = "\e[0m"

  TERM_WIDTH = `tput cols`.to_i > 80 ? 80 : `tput cols`.to_i
end
