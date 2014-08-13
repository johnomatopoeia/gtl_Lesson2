# Blackjack is a game in which players sit at a table and are dealt cards by a dealer into their hands.  First they place bets.
# The dealer shuffles multiple decks of cards before dealing one card at a time to each player at the table including himself.
# Then each player is able to hit, stand, double down, and possibly split their hand.  Once the final player is done
# the dealer has to hit if they have less than 17 and stand if they have 17 or more.
module Clearable
  def clear
    system "clear"
  end
end

class Deck
  attr_accessor :card_deck

  def initialize
      @card_deck = []
      shuffle_decks
  end

  def shuffle_decks
    self.card_deck = []

    suits = ['♦','♣','♠', '♥']
    cards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]

    #combine suits and cards 4 times to create 4 decks
    suits.each do |suit|
    6.times do cards.each {|c| self.card_deck << "#{c.to_s}-#{suit}"} end
      end
    4.times do self.card_deck.shuffle! end #might as well make sure they're shuffled :)
    self.card_deck
  end

  def deal(player_cards, dealer_cards)
    player_cards << card_deck.shift
    dealer_cards << card_deck.shift
  end

  def cut_check
    if self.card_deck.count < 52
      self.shuffle_decks
    end
  end

end

class Player
  include Clearable
  attr_accessor :name, :wants_to_play, :bankroll, :hand, :bet
  def initialize (n)
      @name = n
      @wants_to_play = 'Y'
      @bankroll = 10000
      @hand = []
      @bet = 0
  end

  def hit

  end

  def stand

  end

  def make_move

  end

  def next_hand
    self.hand = []
    self.bet = 0
    puts "Would you like to keep playing? (Y/N)"
    self.wants_to_play = gets.chomp.upcase
  end
end

class Better < Player
  def double_down

  end

  def split

  end

  def place_bet
    until self.bet > 0 && self.bet < self.bankroll do
      puts "#{self.name}, you have #{self.bankroll}. What's your wager?"
      self.bet = gets.chomp.to_i
      clear
    end
  end
end

class Dealer < Player

  def calculate_payouts

  end

  def pay_or_take_bets

  end

end



class Game
  attr_accessor :game_deck, :player1, :game_dealer
  def initialize
    @game_deck = Deck.new
    puts "Welcome to the Haphazard Horshoe Casino! What's your name?"
    @player1 = Better.new(gets.chomp)
    @game_dealer = Dealer.new("MAC")
  end

  def display_cards(gambler,table_dealer,hide)
      if hide == "yes"
        puts "********************\n Dealer Hand\n #{table_dealer.hand[0]} XX \n********************\n\n"
        puts "********************\n Your Hand\n #{gambler.hand} \n********************"
      else
        puts "********************\n Dealer Hand\n #{table_dealer.hand} XX \n********************\n\n"
        puts "********************\n Your Hand\n #{gambler.hand} \n********************"
      end

  end

  def calculate_hand_values

  end

  def play
    player1.place_bet
    2.times do game_deck.deal(player1.hand,game_dealer.hand) end
    display_cards(player1,game_dealer,"yes")

    puts player1.bet
  end
end

Game.new.play
