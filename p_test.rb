require "http"
require "tty-prompt"
require "tty-table"
require "io/console"
require "rmagick"
require "artii"
require "pastel"

# Method to convert RGB values to an ANSI escape code for background color
def rgb_to_ansi_bg(r, g, b)
  "\e[48;2;#{r};#{g};#{b}m"
end

# Get the terminal dimensions
term_width, term_height = IO.console.winsize

# Read and resize the image
img = Magick::Image::read("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/red-blue/132.png").first

img.each_pixel do |pixel, col, row|
  r, g, b = [pixel.red, pixel.green, pixel.blue].map { |v| (v * 255.0 / 65535.0).round }
  if pixel.alpha == Magick::OpaqueAlpha # Check if the pixel is fully opaque
    print "#{rgb_to_ansi_bg(r, g, b)}  \e[0m"
  else
    print "\e[0m  "
  end
  puts if col >= img.columns - 1
end
puts "h" * 80

def title
  color = Pastel.new
  puts color.bold.blue.on_yellow("                                   ,'\\                              ")
  puts color.bold.blue.on_yellow("    _.----.         ____         ,'  _\\   ___    ___     ____       ")
  puts color.bold.blue.on_yellow("_,-'        `.     |    |  /`.   \\,-'    |   \\  /   |   |    \\  |`. ")
  puts color.bold.blue.on_yellow("\\      __     \\    '-.  | /   `.  ___    |    \\/    |   '-.   \\ |  |")
  puts color.bold.blue.on_yellow(" \\.    \\ \\    |  __  |  |/    ,','_  `.  |          | __  |    \\|  |")
  puts color.bold.blue.on_yellow("   \\    \\/   /,' _ `.|      ,' / / / /   |          ,' _`.|     |  |")
  puts color.bold.blue.on_yellow("    \\     ,-'/  /    \\    ,'   | \\/ / ,`.|         /  /   \\  |     |")
  puts color.bold.blue.on_yellow("     \\    \\ |   \\_/   |   `-.  \\    `'  /|  |    ||   \\_/  | |\\    |")
  puts color.bold.blue.on_yellow("      \\    \\ \\       /       `-.`.___,-' |  |\\  /| \\      /  | |   |")
  puts color.bold.blue.on_yellow("       \\    \\ `.__,' |  |`-._    `|      |__| \\/ |  `.__,'|  | |   |")
  puts color.bold.blue.on_yellow("        \\_.-'        |__|    `-._ |              '-.|     '-.| |   |")
  puts color.bold.blue.on_yellow("                                 `'                            '-._|")
end

title

# Create a Draw object
draw = Magick::Draw.new

# Set the font and point size
draw.font = "Courier" # Example of a monospaced font
draw.pointsize = 12

# Measure the width of a space character
metrics = draw.get_type_metrics("h")

# Print the width of the space character
puts "Width of a space character: #{metrics.width} pixels"
puts img.rows
