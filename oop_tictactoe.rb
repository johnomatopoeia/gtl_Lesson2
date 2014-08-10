require 'pry'

module Clearable
  def reset_screen
    system "clear"
  end
end


class PlayBoard

  include Clearable

  attr_accessor :board_hash, :play_line, :empty_board_hash
  attr_reader :standard_line, :divider_line, :space_height, :row_cnt

  def initialize
    @standard_line = "           |     |     "
    @divider_line = "      -----|-----|-----"
    @board_hash = {"1" => " ", "2" => " ", "3" => " ", "4" => " ", "5" => " ", "6" => " ", "7" => " ", "8" => " ", "9" => " ", "0" => "SPACE"}
    @space_height = 3
    @row_cnt = 3
    set_play_line
  end

  def set_play_line
    @play_line = "        #{board_hash.fetch("1")}  |  #{board_hash.fetch("2")}  |  #{board_hash.fetch("3")}  "
  end

  def empty_space_check
    self.board_hash.value?(" ")
  end

  def reset_board
    self.board_hash = {"1" => " ", "2" => " ", "3" => " ", "4" => " ", "5" => " ", "6" => " ", "7" => " ", "8" => " ", "9" => " ", "0" => "SPACE"}
  end

  def draw_board(row_cnt,space_height )
    set_play_line
    reset_screen
    puts "********************************************************\n*            SUPER FUN TIC TAC TOE TIME!!!!            *\n********************************************************\n\n"
    row_cnt.times do

      space_height.times do
        if space_height == 2
          # replace characters positions 2, 6, and 10 with space values from board hash
          puts play_line
        else
          puts standard_line
        end

         space_height -= 1

        if space_height == 0 && row_cnt > 1
          puts divider_line
        end

      end
      row_cnt -= 1
      space_height = self.space_height

      if row_cnt == 2
        self.play_line = "        #{board_hash.fetch("#{row_cnt+2}")}  |  #{board_hash.fetch("#{row_cnt+3}")}  |  #{board_hash.fetch("#{row_cnt+4}")}  "
      else
        self.play_line = "        #{board_hash.fetch("#{row_cnt+6}")}  |  #{board_hash.fetch("#{row_cnt+7}")}  |  #{board_hash.fetch("#{row_cnt+8}")}  "
      end

    end

  end

end

class ScoreBoard
    attr_accessor :wins, :losses, :draws, :winner
  attr_reader :winning_combos

  def initialize
     @wins = 0
     @losses = 0
     @draws = 0
     @winner = " "
     @winning_combos = [["1", "2", "3"], ["4", "5", "6"], ["4", "5", "6"],["7", "8", "9"], ["1", "4", "7"], ["2", "5", "8"], ["3", "6", "9"], ["1", "5", "9"], ["3", "5", "7"]]
  end

  def winner_check(moves, player, type)
    winning_combos = [["1", "2", "3"], ["4", "5", "6"], ["4", "5", "6"],["7", "8", "9"], ["1", "4", "7"], ["2", "5", "8"], ["3", "6", "9"], ["1", "5", "9"], ["3", "5", "7"]]
    champion = ""
    winning_combos.each do |v|
      if (v & moves).count == 3
        champion =  "#{player}"
      end
    end

    if champion == player
      self.winner = champion
      if type == "Human"
        self.wins += 1
      elsif type == "Computer"
        self.losses += 1
      end
      throw :win
    end

  end

  def reset_winner
    self.winner = " "
  end

  def show_score(player)
    if self.winner == " "
      puts "Its a tie!"
      self.draws += 1
    else
      puts "#{self.winner} wins!"
    end
    puts "#{player}, your current score is:\n#{wins} Wins, #{losses} Losses, and #{draws} Draws"
  end
end

class Player
  attr_accessor :name, :hand

  def initialize(n)
    @name = n
    @spaces = []
  end

  def choose_space(name,game_board)
    space = "0"
    # a little messy to make sure the player chooses an unoccupied space and a space that actually exists :)
    if self.class.name == "Human"
      space = "99"
      while  game_board.board_hash.has_key?(space) != true do
        puts "#{name}, Choose your space: 1 - 9"
        space = gets.chomp
        while game_board.board_hash.fetch(space) != " " do
          puts "Please choose an unoccupied space. (1-9)"
          space = gets.chomp
          if game_board.board_hash.has_key?(space) != true
            space = "0"
          end
        end

      end
    else
      while game_board.board_hash.fetch(space) != " " do
        space = game_board.board_hash.keys.sample
      end
    end

    if game_board.empty_space_check == true
      game_board.board_hash[space] = self.class.name == "Human" ? "X" : "O"
    end
  end
end

class Human < Player

end

class Computer < Player

end

class Game
  include Clearable

  attr_accessor :player, :computer, :jumbotron, :play_again, :game_board

  def initialize
    reset_screen
    puts "What is your name, contestant?"
    @player = Human.new(gets.chomp)
    @computer = Computer.new("MAC")
    @jumbotron = ScoreBoard.new
    @game_board = PlayBoard.new
    @play_again = "Y"
  end

  def play
    while self.play_again == "Y" do
      jumbotron.reset_winner
      game_board.reset_board
      game_board.draw_board(game_board.row_cnt,game_board.space_height)

      # puts player.name
      # puts computer.name

      catch :win do
        while game_board.empty_space_check == true && jumbotron.winner == " " do
          puts play_again
          puts jumbotron.winner
          puts game_board.board_hash
          puts game_board.empty_board_hash
          player.choose_space(player.name,game_board)
          if jumbotron.winner == " "
            computer.choose_space(computer.name,game_board)
          end

        game_board.draw_board(game_board.row_cnt,game_board.space_height)

        jumbotron.winner_check(game_board.board_hash.keys.select { |key| game_board.board_hash[key] == "X"},player.name, player.class.name)
        jumbotron.winner_check(game_board.board_hash.keys.select { |key| game_board.board_hash[key] == "O"},computer.name, computer.class.name)
        end #end spaces loop
      end # end win catch
      jumbotron.show_score(player.name)
      puts "Would you like to play again? (Y/N)"
      self.play_again = gets.chomp.upcase
    end #end play again
  end #end play
end


Game.new.play

