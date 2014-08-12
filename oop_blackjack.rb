# Blackjack is a game in which players sit at a table and are dealt cards by a dealer into their hands.  First they place bets.
# The dealer shuffles multiple decks of cards before dealing one card at a time to each player at the table including himself.
# Then each player is able to hit, stand, double down, and possibly split their hand.  Once the final player is done
# the dealer has to hit if they have less than 17 and stand if they have 17 or more.


class Player
  def initialize (n)
      @name = n
      @bankroll = 10000
  end

  def hit

  end

  def stand

  end
end

class Better < Player
  def double_down

  end

  def split

  end

class Dealer < Player

  def calculate_payouts

  end


end

class Table
  def display_cards

  end

  def calculate_hand_values

  end
end

class Deck

  def shuffling

  end

  def deal

  end
end

class Bankroll
  def
  track bets
end

class Game

end


