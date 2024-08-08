require "http"
require "tty-prompt"
require "tty-table"
require "io/console"
require "rmagick"
require "artii"
require "pastel"
require "paint"

color = Pastel.new

def title
  def t_color(string)
    Pastel.new.bold.yellow(string)
  end

  puts "                                   " + t_color(",'\\") + "                              "
  puts "    " + t_color("_.----.") + "         " + t_color("____") + "         " + t_color(",'  _\\") + "   " + t_color("___") + "    " + t_color("___") + "     " + t_color("____") + "       "
  puts t_color("_,-'        `.") + "     " + t_color("|    |") + "  " + t_color("/`.") + "   " + t_color("\\,-'") + "    " + t_color("|   \\") + "  " + t_color("/   |") + "   " + t_color("|    \\") + "  " + t_color("|`.") + " "
  puts t_color("\\      __     \\") + "    " + t_color("'-.  |") + " " + t_color("/   `.") + "  " + t_color("___") + "    " + t_color("|    \\/    |") + "   " + t_color("'-.   \\") + " " + t_color("|  |")
  puts " " + t_color("\\.    \\ \\    |") + "  " + t_color("__") + "  " + t_color("|  |/    ,','_  `.") + "  " + t_color("|          |") + " " + t_color("__") + "  " + t_color("|    \\|  |")
  puts "   " + t_color("\\    \\/   /,' _ `.|      ,'") + " " + t_color("/ / / /") + "   " + t_color("|          ,' _`.|     |  |")
  puts "    " + t_color("\\     ,-'/  /    \\    ,'") + "   " + t_color("| \\/ /") + " " + t_color(",`.|         /  /   \\  |     |")
  puts "     " + t_color("\\    \\") + " " + t_color("|   \\_/   |   `-.") + "  " + t_color("\\    `'  /|  |    ||   \\_/  | |\\    |")
  puts "      " + t_color("\\    \\") + " " + t_color("\\       /       `-.`.___,-'") + " " + t_color("|  |\\  /| \\      /  |") + " " + t_color("|   |")
  puts "       " + t_color("\\    \\") + " " + t_color("`.__,'") + " " + t_color("|  |`-._    `|") + "      " + t_color("|__|") + " " + t_color("\\/") + " " + t_color("|  `.__,'|  |") + " " + t_color("|   |")
  puts "        " + t_color("\\_.-'") + "        " + t_color("|__|") + "    " + t_color("`-._ |") + "              " + t_color("'-.|") + "     " + t_color("'-.|") + " " + t_color("|   |")
  puts "                                 " + t_color("`'") + "                            " + t_color("'-._|")
end

system "clear"
title
# pokemon = "pikachu" # << Test <<
# begin
#   print "Enter Pokémon: "
#   pokemon = gets.chomp.downcase
#   response = HTTP.get("https://pokeapi.co/api/v2/pokemon/#{pokemon}")
# rescue HTTP::Error
#   puts "Enter a real Pokémon(or a correctly spelled one):"
#   pokemon = gets.chomp.downcase
#   response = HTTP.get("https://pokeapi.co/api/v2/pokemon/#{pokemon}")
# end

while true
  print "Enter Pokémon: "
  pokemon = gets.chomp.downcase
  # fuzzy search plus availability of evolved forms
  response = HTTP.get("https://pokeapi.co/api/v2/pokemon/#{pokemon}")

  # Check if the response is successful
  if response.status.success?
    break
  else
    system "clear"
    title
    puts "Invalid Pokémon name. Please try again."
  end
end
data = response.parse
# Add return for fake/mispelled pokemon instead of error screen
# begin/rescue
# ^^ keep in final code ^^

# Create version selector for moves (and more potentially?) next using tty-prompt
prompt = TTY::Prompt.new
versions = %w(
  Red_and_Blue
  Yellow
  Gold_and_Silver
  Crystal
  Ruby_and_Sapphire
  FireRed_and_LeafGreen
  Emerald
  Colosseum
  XD:_Gale_of_Darkness
  Diamond_and_Pearl
  Platinum
  HeartGold_and_SoulSilver
  Black_and_White
  Black_2_and_White_2
  X_and_Y
  Omega_Ruby_and_Alpha_Sapphire
  Sun_and_Moon
  Ultra_Sun_and_Ultra_Moon
  Let's_Go,_Pikachu!_and_Let's_Go,_Eevee!
  Sword_and_Shield
  Brilliant_Diamond_and_Shining_Pearl
  Scarlet_and_Violet
)

version_choice = prompt.select("Select version:", versions)
# Add return for mismatch of pokemon with generation instead of error
version = version_choice
version_hash = {
  "Red_and_Blue" => ["red-blue", data["sprites"]["versions"]["generation-i"]["red-blue"]["front_default"]],
  "Yellow" => ["yellow", data["sprites"]["versions"]["generation-i"]["yellow"]["front_default"]],
  "Gold_and_Silver" => ["gold-silver", data["sprites"]["versions"]["generation-ii"]["gold"]["front_default"]],
  "Crystal" => ["crystal", data["sprites"]["versions"]["generation-ii"]["crystal"]["front_default"]],
  "Ruby_and_Sapphire" => ["ruby-sapphire", data["sprites"]["versions"]["generation-iii"]["ruby-sapphire"]["front_default"]],
  "FireRed_and_LeafGreen" => ["firered-leafgreen", data["sprites"]["versions"]["generation-iii"]["firered-leafgreen"]["front_default"]],
  "Emerald" => ["emerald", data["sprites"]["versions"]["generation-iii"]["emerald"]["front_default"]],
  "Diamond_and_Pearl" => ["diamond-pearl", data["sprites"]["versions"]["generation-iv"]["diamond-pearl"]["front_default"]],
  "Platinum" => ["platinum", data["sprites"]["versions"]["generation-iv"]["platinum"]["front_default"]],
  "HeartGold_and_SoulSilver" => ["heartgold-soulsilver", data["sprites"]["versions"]["generation-iv"]["heartgold-soulsilver"]["front_default"]],
  "Black_and_White" => ["black-white", data["sprites"]["versions"]["generation-v"]["black-white"]["front_default"]],
  "Black_2_and_White_2" => ["black-2-white-2", data["sprites"]["versions"]["generation-v"]["black-white"]["front_default"]],
  "X_and_Y" => ["x-y", data["sprites"]["versions"]["generation-vi"]["x-y"]["front_default"]],
  "Omega_Ruby_and_Alpha_Sapphire" => ["omega-ruby-alpha-sapphire", data["sprites"]["versions"]["generation-vi"]["omegaruby-alphasapphire"]["front_default"]],
  "Sun_and_Moon" => ["sun-moon", data["sprites"]["versions"]["generation-vii"]["icons"]["front_default"]],
  "Ultra_Sun_and_Ultra_Moon" => ["ultra-sun-ultra-moon", data["sprites"]["versions"]["generation-vii"]["ultra-sun-ultra-moon"]["front_default"]],
  "Let's_Go,_Pikachu!_and_Let's_Go,_Eevee!" => ["lets-go-pikachu-lets-go-eevee", data["sprites"]["versions"]],
  "Sword_and_Shield" => ["sword-shield", data["sprites"]["versions"]],
  "Brilliant_Diamond_and_Shining_Pearl" => ["brilliant-diamond-and-shining-pearl", data["sprites"]["versions"]],
  "Scarlet_and_Violet" => ["scarlet-violet", data["sprites"]["versions"]],
}

if version == "Colosseum"
  version = "colosseum"
  png = data["sprites"]["other"]["showdown"]["front_default"]
elsif version == "XD:_Gale_of_Darkness"
  version = "xd"
  png = data["sprites"]["other"]["showdown"]["front_default"]
else
  png = version_hash[version][1]
  version = version_hash[version][0]
end

if png == nil
  puts "Wrong generation selected. Please try again"
  sleep(2)
  system "ruby pokedex.rb"
end

system "clear"

# Pokemon Sprite
# Method to convert RGB values to an ANSI escape code for background color
def rgb_to_ansi_bg(r, g, b)
  "\e[48;2;#{r};#{g};#{b}m"
end

# Get the terminal dimensions
term_width, term_height = IO.console.winsize

# Read and resize the image
img = Magick::Image::read(png).first
# img = img.resize_to_fit(term_width, term_height) # << needs to be configured carefully
img_height = img.columns
img_width = img.rows
a = Artii::Base.new(font: "small")
chr = " "
pkdx_nmbr = a.asciify("##{data["id"]}").length / 5
pkmn_name = a.asciify("#{data["name"]}").length / 5
bar_length = (img_width * 2) - pkdx_nmbr - pkmn_name - 2
# length of ASCII art first
# Present visuals about Pokemon
# title
puts
puts color.bold.on_red(a.asciify("  ##{data["id"]}" + (chr * bar_length) + "#{data["name"].capitalize}  "))
# "#25        Pikachu"

img.each_pixel do |pixel, col, row|
  r, g, b = [pixel.red, pixel.green, pixel.blue].map { |v| (v * 255.0 / 65535.0).round }
  if pixel.alpha == Magick::OpaqueAlpha # Check if the pixel is fully opaque
    print "#{rgb_to_ansi_bg(r, g, b)}  \e[0m"
  else
    print "\e[0m  "
  end
  puts if col >= img.columns - 1
end

# Pokemon data
#
# Do types on color
# Types list (+ color):
# Normal (grey/light green)
# Fire (orange)
# Water (blue)
# Electric (yellow)
# Grass (green)
# Ice (light blue)
# Fighting (red)
# Poison (purple)
# Ground (light brown)
# Flying (light purple)
# Psychic (pink)
# Bug (dark green)
# Rock (brown)
# Ghost (purple)
# Dragon (purple)
# Dark (dark brown)
# Steel (silver)
# Fairy (light pink)
# color.on_<color>("<type>")

types = {
  "normal" => color.on_bright_green("NORMAL"),
  "fire" => color.on_bright_red("FIRE"),
  "water" => color.on_blue("WATER"),
  "electric" => color.on_yellow("ELECTRIC"),
  "grass" => color.on_green("GRASS"),
  "ice" => color.on_cyan("ICE"),
  "fighting" => color.on_red("FIGHTING"),
  "poison" => color.on_magenta("POISON"),
  "ground" => color.on_bright_black("GROUND"),
  "flying" => color.on_bright_magenta("FLYING"),
  "psychic" => color.on_bright_red("PSYCHIC"),
  "bug" => color.on_green("BUG"),
  "rock" => color.on_bright_black("ROCK"),
  "ghost" => color.on_magenta("GHOST"),
  "dragon" => color.on_magenta("DRAGON"),
  "dark" => color.on_black("DARK"),
  "steel" => color.on_bright_black("STEEL"),
  "fairy" => color.on_bright_red("FAIRY"),
}

puts
if data["types"][1] != nil
  type1 = data["types"][0]["type"]["name"]
  type2 = data["types"][1]["type"]["name"]
  puts "Type: #{types[type1]}, #{types[type2]}"
else
  type = data["types"][0]["type"]["name"]
  puts "Type: #{types[type]}"
end

puts
puts color.bold("Ability: #{data["abilities"][0]["ability"]["name"]}")
height = data["height"].to_f / 10
puts color.bold("Height: #{height} m")
weight = data["weight"].to_f / 10
puts color.bold("Weight: #{weight} kg")

# Stats Table
puts
puts
puts color.bold("Base Stats:")
statstable = TTY::Table.new(header: ["Stat Name", "Base Stat"])
data["stats"].each do |stat|
  statstable << [stat["stat"]["name"], stat["base_stat"]]
end
puts statstable.render(:unicode)

# Move Table
puts
puts color.bold("Level-Up Move List:")
puts "(Version: #{version_choice})"
ordered_levels = []
data["moves"].each do |move|
  move["version_group_details"].each do |level|
    if level["move_learn_method"]["name"] == "level-up" && level["version_group"]["name"] == version
      ordered_levels << level["level_learned_at"]
    end
  end
end
ordered_levels = ordered_levels.uniq.sort

movetable = TTY::Table.new(header: ["Level", "Move"])
data["stats"].each do |stat|
  [stat["stat"]["name"], stat["base_stat"]]
end

ordered_levels.each do |level|
  data["moves"].each do |move|
    move["version_group_details"].each do |s_move|
      if s_move["level_learned_at"] == level && s_move["version_group"]["name"] == version
        movetable << [level, move["move"]["name"]]
      end
    end
  end
end

puts movetable.render(:unicode)
puts
