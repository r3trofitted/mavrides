Card = Data.define(:value, :suit) do
  self::SUITS  = %i[clubs diamonds hearts spades]
  self::VALUES = %i[1 2 3 4 5 6 7 8 9 jack queen king ace]
  self::EMOJIS = { spades: "♠️", clubs: "♣️", hearts: "♥️", diamonds: "♦️" }

  class << self
    def load(payload)
      if payload.present?
        v, s = payload.scan(/\X/) # \X matches a single Unicode grapheme (necessary because the emojis are grapheme _clusters_)

        value = Card::VALUES.detect { |s| s.start_with?(/#{v}/i) }
        suit  = Card::EMOJIS.key(s)

        Card.new value:, suit:
      end
    end

    def dump(card)
      card.to_short_s
    end

    def new_hand
      Card::SUITS.map { |s| new(value: Card::VALUES.sample, suit: s) }
    end
  end

  def initialize(value:, suit:)
    value = value.to_s.to_sym.presence_in(Card::VALUES) or raise ArgumentError
    suit  = suit.to_sym.presence_in(Card::SUITS) or raise ArgumentError

    super value:, suit:
  end

  def to_short_s
    value[0].upcase << Card::EMOJIS.fetch(suit)
  end
end
