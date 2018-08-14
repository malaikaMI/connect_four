require_relative 'connect_four.rb'
system('cls')
puts ''
puts ''
puts "                     ~ Connect Four ~                 "
puts %{is a two-player connection game in which the players
first choose a color and then take turns dropping colored discs
from the top into a seven-column, six-row vertically suspended grid.
The pieces fall straight down, occupying the next available space
within the column. The objective of the game is to be the first to form
a horizontal, vertical, or diagonal line of four of one's own discs.}
puts ''
puts ''

puts "Player 1, What is your name?"
name1 = gets.chomp.capitalize
puts "#{name1}, which color do you want to play in this game?"
color1 = gets.chomp[0].upcase

puts "Player 2, What is your name?"
name2 = gets.chomp.capitalize
puts "#{name2}, which color do you want to play in this game?"
color2 = gets.chomp[0].upcase
while color2 == color1
  puts "#{name2}, your color is taken, please choose other color:"
  color2 = gets.chomp[0].upcase
end

player1 = ConnectFour::Players.new(color1,name1)
player2 = ConnectFour::Players.new(color2,name2)
game = ConnectFour::Game.new([player1, player2])
puts game.start
