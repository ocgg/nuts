module Styles
  BOLD = 1
  DIM = 2
  ITALIC = 3
  UNDERLINE = 4
  REVERSE = 7
  STRIKE = 9

  RGB_GRAY = [38, 2, 120, 120, 120]
  RGB_DARKGRAY = [38, 2, 45, 45, 45]
  RGB_BG_DARKGRAY = [48, 2, 45, 45, 45]
  NOCOLOR = "\e[0m"

  # Custom
  CODE_COL = RGB_DARKGRAY
  CODE_BG = RGB_BG_DARKGRAY

  TERM_WIDTH = (`tput cols`.to_i > 80) ? 80 : `tput cols`.to_i
end
