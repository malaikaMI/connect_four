module ConnectFour
    class Board
      attr_accessor :grids
  
      def initialize
        @grids = {}
        insert_coordinates
      end
  
      def generate_coordinates
        arr = []
        0.upto(6) { |x| 0.upto(5) { |y| arr << [x,y] } }
        arr
      end
  
      def insert_coordinates
        arr = generate_coordinates
        arr.each do |key|
          @grids[key] = ' '
        end
      end
  
      def display
        system('cls')
        puts ''
        puts ''
        puts "                     ~ Connet Four ~"
        puts "              +" + "---+"*7
        5.downto(0) do |y|
          string = '              |'
          for x in (0..6) do
            string += " #{@grids[[x, y]]} |"
          end
          puts string
          puts "              +" + "---+"*7
        end
        puts "                0   1   2   3   4   5   6"
        puts ''
        puts ''
      end
  
    end
  
    class Players
      attr_accessor :color, :name
  
      def initialize(color,name)
        @color = color
        @name = name
      end
    end
  
     class Game
       attr_accessor :players, :board, :current_player, :other_player
  
       def initialize(players, board = Board.new)
         @players = players
         @board = board
         @current_player, @other_player = players.shuffle
       end
  
       def start
         @board.display
         string = 'The game is over. '
         until end?
           make_a_move(ask_player)
           @board.display
           break if win?
           switch_players
         end
         string += draw? ? "You are draw!" : "The winner is #{@current_player.name}. Congratulations!!"
      end
  
       def ask_player
         puts "Hi, #{@current_player.name}, please choose which collumn (x) you want throw the ball?"
         x = gets.chomp.to_i
         while (0..6).include?(x) != true
           puts "Invalid input, please input 0 to 6:"
           x = gets.chomp.to_i
         end
         x
       end
  
       def switch_players
         @current_player, @other_player = @other_player, @current_player
       end
  
       def make_a_move(x)
         for y in (0..5) do
           if @board.grids[[x,y]] == ' '
             @board.grids[[x,y]] = @current_player.color
             break
           end
         end
       end
  
       def win?
         check_horizonally || check_vertically || check_diagonally
       end
  
       def check_horizonally
         for y in (0..5) do
           count = 0
           for x in (0..6) do
             @board.grids[[x,y]] == @current_player.color ? count += 1 : count = 0
             return true if count >= 4
           end
         end
         false
       end
  
       def check_vertically
         for x in (0..6) do
           next if  @board.grids[[x, 0]] == ' '
           count = 0
           for y in (0..5) do
             @board.grids[[x,y]] == @current_player.color ? count += 1 : count = 0
             return true if count >= 4
           end
         end
         false
       end
  
       def check_diagonally
         mark_hash = @board.grids.select{ |key, value| value == @current_player.color }
         mark_arr = mark_hash.keys.sort_by{ |key| key[1] }
         diagonally_ascend(mark_arr) || diagonally_descend(mark_arr)
       end
  
      def diagonally_ascend(mark_arr)
        mark_arr.each do |key|
          count = 0
          temp = key
          while mark_arr.include?([temp[0] + 1, temp[1] + 1])
            count += 1
            temp = [temp[0] + 1, temp[1] + 1]
            mark_arr - [temp[0] + 1, temp[1] + 1]
          end
          return true if count >= 3
        end
        false
      end
  
      def diagonally_descend(mark_arr)
        mark_arr.each do |key|
          count = 0
          temp = key
          while mark_arr.include?([temp[0] + 1, temp[1] - 1])
            count += 1
            temp = [temp[0] + 1, temp[1] - 1]
            mark_arr - [temp[0] + 1, temp[1] - 1]
          end
          return true if count >= 3
        end
        false
      end
  
      def end?
        @board.grids.none?{|key,value| value == ' '}
      end
  
      def draw?
        ( end? && win? != true ) ? true : false
      end
  
    end
  
  end