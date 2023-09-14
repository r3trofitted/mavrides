Card = Data.define(:value, :suit) do
  self::SUITS  = %i[clubs diamonds hearts spades]
  self::VALUES = %i[1 2 3 4 5 6 7 8 9 jack queen king ace]
  
  def initialize(value:, suit:)
    value = value.to_s.to_sym.presence_in(Card::VALUES) or raise ArgumentError
    suit  = suit.to_sym.presence_in(Card::SUITS) or raise ArgumentError
    
    super(value:, suit:)
  end
  
  def to_short_s
    value[0].upcase << { spades: "♠️", clubs: "♣️", hearts: "♥️", diamonds: "♦️" }.fetch(suit)
  end
end
