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

  def give_one_card(player)
    card_deck.shift
  end

  def cut_check
    if self.card_deck.count < 52
      self.shuffle_decks
    end
  end

end

class Player
  include Clearable
  attr_accessor :name, :wants_to_play, :bankroll, :hand, :hand_value, :bet, :player_move, :blackjack, :busted
  def initialize (n)
      @name = n
      @wants_to_play = 'Y'
      @bankroll = 10000
      @hand = []
      @hand_value = 0
      @player_move = ""
      @bet = 0
      @busted = false
      @blackjack = false
  end

  def clear_hand
      self.hand = []
      self.hand_value = 0
      self.player_move = ""
      self.bet = 0
      self.busted = false
      self.blackjack = false
  end

  def hit(deck)
    self.hand << deck.give_one_card(self)
  end

  def stand(move)
    self.player_move = move
  end

  def double_down(move,deck)
    self.player_move = move
    self.hit(deck)
    self.bet *= 2
  end

  def double_check
    self.bankroll >= (self.bet * 2)
  end

  def split

  end


  def make_move(player,deck)
    move_choice = ""
    until ["H","S"].include?(move_choice) == true || (move_choice == "D" && player.double_check == true ) do
      if player.double_check == true
        puts "#{player.name}, what would you like to do hit (H), stand (S), or double down(D)?"
      else
        puts "#{player.name}, what would you like to do hit (H)or stand (S)?"
      end
      move_choice = gets.chomp.upcase
    end

    case move_choice
    when "H"
      player.hit(deck)
    when "S"
      player.stand(move_choice)
    when "D"
      player.double_down(move_choice,deck)
      # self.player_move = move_choice
    end
  end

end

class Better < Player

  def place_bet
    until self.bet > 0 && self.bet <= self.bankroll do
      puts "#{self.name}, you have #{self.bankroll}. What's your wager?"
      self.bet = gets.chomp.to_i
      clear
    end
  end

  def next_hand()
    if self.bankroll > 0
      puts "Would you like to keep playing? (Y/N)"
      self.wants_to_play = gets.chomp.upcase
    else
      puts "You're bankrupt!!! Better luck next time. (Press Enter To Continue)"
      self.wants_to_play = "N"
      gets.chomp
    end
  end
end

class Dealer < Player

  def calculate_payouts(player)
      if player.blackjack == true and self.blackjack == false
        player.bankroll += (1.5*player.bet)
      elsif player.busted == true
        player.bankroll -= player.bet
      elsif self.busted == true
        player.bankroll += player.bet
      elsif self.hand_value > player.hand_value
        player.bankroll -= player.bet
      elsif player.hand_value > self.hand_value
        player.bankroll += player.bet
      end
      player.bet = 0
      puts "#{player.name}, you now have #{player.bankroll}"
  end

end



class Game
  include Clearable
  attr_accessor :game_deck, :player1, :game_dealer, :end_hand_type
  def initialize
    clear
    @game_deck = Deck.new
    puts "Welcome to the Haphazard Horshoe Casino! What's your name?"
    @player1 = Better.new(gets.chomp)
    @game_dealer = Dealer.new("MAC")
    @end_hand_type = "normal"

  end

  def display_cards(gambler,table_dealer,hide)
    clear
      if hide == "yes"
        puts "********************\n Dealer Hand\n #{table_dealer.hand[0]} XX \n********************\n\n"
        puts "********************\n Your Hand\n #{gambler.hand} \n********************"
      else
        puts "********************\n Dealer Hand\n #{table_dealer.hand} \n********************\n\n"
        puts "********************\n Your Hand\n #{gambler.hand} \n********************"
      end

  end

  def calculate_hand_values(player)
    ace_count = 0
    total = 0
    #iterate through cards to check for face cards and calculate total
    player.hand.each do |c|
      if c.partition('-').first.to_i > 0
        total += c.partition('-').first.to_i if c != 'A'
      else
        if c.partition('-').first == 'A'
          #checking for aces to evaluate after all other cards totaled b/c they can be 1 or 11
          ace_count += 1
        else
          total += 10
        end
      end
    end

    #ace handling
    if total > 10
      total += ace_count
    else
      ace_count.times do
        if total > 10 or total + ace_count > 10
          total += ace_count
        else
          total += 11
          ace_count -= 1
        end
      end
    end

   player.hand_value = total
  end

  def blackjack_check(player,dealer)
    if player.hand_value == 21
      self.end_hand_type = "blackjack"
      player.blackjack = true
    end
    if dealer.hand_value == 21
      self.end_hand_type = "blackjack"
      dealer.blackjack = true
    end
    if player.blackjack == true || dealer.blackjack == true
      throw :end_hand
    end

  end

  def bust_check(player)
    if player.hand_value > 21
      self.end_hand_type = "bust"
      player.busted = true
      throw :end_hand
    end
  end

  def who_won?(player,dealer)

    if player.busted == true
      puts "Sorry #{player.name}, you busted."
    elsif dealer.busted == true
      puts "Congratulations #{player.name}, the dealer busted."
    elsif player.hand_value == dealer.hand_value
      puts "It's a push."
    elsif player.blackjack == true
      puts "Winner, winner, chicken dinner! You got blackjack"
    elsif dealer.blackjack == true
      puts "Dealer has blackjack, you lose."
    elsif player.hand_value < dealer.hand_value
      puts "Sorry #{player.name}, the dealer's #{dealer.hand_value} beats your #{player.hand_value}."
    else
      puts "Congratulations #{player.name}, your #{player.hand_value} beats the dealer's #{dealer.hand_value}."
    end

  end

  def reset_hand
    player1.clear_hand

    game_dealer.clear_hand

    clear
  end

  def play
    while player1.wants_to_play == "Y" do
      catch :end_hand do
        player1.place_bet
        2.times do game_deck.deal(player1.hand, game_dealer.hand) end

        calculate_hand_values(game_dealer)
        calculate_hand_values(player1)
        blackjack_check(player1,game_dealer)

        until ["S","D"].include?(player1.player_move) do
          display_cards(player1, game_dealer, "yes")
          calculate_hand_values(player1)
          bust_check(player1)
          player1.make_move(player1, game_deck)
        end
        calculate_hand_values(player1)

        until game_dealer.hand_value > 16 do
          display_cards(player1, game_dealer, "no")
          game_dealer.hit(game_deck)
          calculate_hand_values(game_dealer)
          bust_check(game_dealer)
        end

      end # end_hand

      display_cards(player1, game_dealer, "no")
      puts end_hand_type
      puts player1.hand_value
      puts game_dealer.hand_value
      who_won?(player1, game_dealer)
      game_dealer.calculate_payouts(player1)
      player1.next_hand
      reset_hand
    end #game loop
  end


end

Game.new.play
