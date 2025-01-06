require_relative "styles"

module Titles
  include Styles

  def title(str)
    if str.start_with?("###### ") then h6(str)
    elsif str.start_with?("##### ") then h5(str)
    elsif str.start_with?("#### ") then h4(str)
    elsif str.start_with?("### ") then h3(str)
    elsif str.start_with?("## ") then h2(str)
    elsif str.start_with?("# ") then h1(str)
    end
  end

  private

  def h1(str)
    upline = render_txt("┌#{"─" * (TERM_WIDTH - 2)}┐")
    downline = render_txt("└#{"─" * (TERM_WIDTH - 2)}┘")
    side = render_txt("│")
    midlines = to_lines(str[2..], TERM_WIDTH - 2).map do |line|
      line = line.center(TERM_WIDTH - 2 - 2) # -2 for sides & spaces
      line = render_txt(line, BOLD)
      "#{side} #{line} #{side}"
    end.join("\n")
    "#{upline}\n#{midlines}\n#{downline}"
  end

  def h2(str)
    downline = render_txt("─" * TERM_WIDTH)
    lines = to_lines(str[3..]).map { |line| line.ljust(TERM_WIDTH) }.join("\n")
    lines = render_txt(lines, BOLD)
    "#{lines}\n#{downline}"
  end

  def h3(str) = render_txt(str[4..], BOLD, UNDERLINE)

  def h4(str) = render_txt(str[5..], UNDERLINE)

  def h5(str) = render_txt(str[6..], BOLD, DIM)

  def h6(str) = render_txt(str[7..], DIM)
end
