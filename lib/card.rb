# Card = Data.define(:value, :suit) do
class Card
  include Comparable

  SUITS  = %i[clubs diamonds hearts spades]
  VALUES = %i[2 3 4 5 6 7 8 9 10 jack queen king ace]
  EMOJIS = { spades: "♠️", clubs: "♣️", hearts: "♥️", diamonds: "♦️" }

  attr_reader :value, :suit

  class << self
    def load(payload)
      if payload.present?
        v, s = payload.scan(/([\dJQKA]{1,2})(\X)/).flatten # \X matches a single Unicode grapheme (necessary because the emojis are grapheme _clusters_)

        value = VALUES.detect { |s| s.start_with? /#{v}/i }
        suit  = EMOJIS.key(s)

        Card.new value:, suit:
      end
    end

    def dump(card)
      card.to_short_s
    end

    def one_of_each_suit
      SUITS.map { |s| new(value: VALUES.sample, suit: s) }
    end
  end

  def initialize(value:, suit:)
    @value = value.to_s.to_sym.presence_in(VALUES) or raise ArgumentError
    @suit  = suit.to_sym.presence_in(SUITS) or raise ArgumentError
  end

  def to_short_s
    @value[0].upcase << EMOJIS.fetch(suit)
  end

  def <=>(other)
    return nil unless other.kind_of? Card

    if suit == other.suit
      value <=> other.value
    else
      suit <=> other.suit
    end
  end
end
