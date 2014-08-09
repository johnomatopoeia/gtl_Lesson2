require 'pry'

class Player
  attr_accessor :name, :hand

  def initialize(n)
    @name = n
  end

  def reset_hand
    self.hand = ""
  end
end

class Human < Player

  def pick_hand
    until Game::HANDS.values.include?(self.hand) == true do
      puts "#{self.name}, choose your weapon: \n(R) Rock  (P) Paper (S) Scissors. Which will it be? (R, P, S)"
      self.hand = Game::HANDS[gets.chomp.upcase]
    end
  end

end

class Computer < Player

  def pick_hand
    self.hand = Game::HANDS[Game::HANDS.keys[rand(3)]]
  end

end

class ScoreBoard

  attr_accessor :wins, :losses, :draws
  attr_reader :winning_hands

  def initialize
     @wins = 0
     @losses = 0
     @draws = 0
     @winning_hands = {"Rock" => ["Scissors"], "Paper" => ["Rock"], "Scissors" => ["Paper"], "Nuke" => ["Rock", "Paper", "Scissors"]}
  end

  def compare_hands(player, computer)
      if player.hand == computer.hand
        puts "********************************************************\n* Everyone brought their #{player.hand}! It's a tie."
        self.draws += 1
      elsif winning_hands[player.hand].include?(computer.hand) == true
        puts "********************************************************\n* #{player.name}, your #{player.hand} beats #{computer.name}'s #{computer.hand}."
        self.wins += 1
      else
        puts "********************************************************\n* #{player.name}, your #{player.hand} was destroyed by #{computer.name}'s #{computer.hand}."
        self.losses += 1
      end

  end

  def show_score(name)
    puts "********************************************************\n* #{name}'s Score\n* #{self.wins} Wins  #{self.losses} Losses #{self.draws} Draws\n********************************************************"


  end

end

class Game
  HANDS = {'R' => 'Rock', 'P' => 'Paper', 'S' => 'Scissors', '666' => 'Nuke'}

  attr_accessor :player, :computer, :jumbotron, :play_again

  def initialize
    reset_screen
    puts "What is your name, contestant?"
    @player = Human.new(gets.chomp)
    @computer = Computer.new("MAC")
    @jumbotron = ScoreBoard.new
    @play_again = "Y"
  end

  def reset_screen
    system "clear"
  end

  def play
    while self.play_again == "Y" do
      reset_screen

      player.pick_hand
      computer.pick_hand

      reset_screen

      jumbotron.compare_hands(player,computer)
      jumbotron.show_score(player.name)

      player.reset_hand

      self.play_again = " "
      puts "Playe again? (Y/N)"
      until ["Y","N"].include?(self.play_again) do
        self.play_again = gets.chomp.upcase
      end
    end
  end

end



Game.new.play

