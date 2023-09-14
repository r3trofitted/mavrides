class Card
  SUITS = [
    CLUBS    = "♣️",
    DIAMONDS = "♦️",
    HEARTS   = "♥️",
    SPADES   = "♠️"
  ]
  
  VALUES = [
    ONE  = "1", TWO = "2",  THREE = "3", FOUR  = "4",
    FIVE = "5", SIX = "6",  SEVEN = "7", EIGHT = "8",
    NINE = "9", TEN = "10", JACK  = "J", QUEEN = "Q",
    KING = "K", ACE = "A"
  ]
  
  def initialize(value:, suit:)
    value = Card.const_get(value.upcase) if value.is_a? Symbol
    suit  = Card.const_get(suit.upcase) if suit.is_a? Symbol
    
    @value, @suit = value.to_s, suit
  end
  
  def to_short_s
    @value << @suit
  end
end
