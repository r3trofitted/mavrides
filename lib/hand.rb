class Hand
  include Enumerable

  SEPARATOR = ","

  delegate :each, :empty?, to: :@cards

  def self.load(payload)
    if payload.present?
      cards = payload.split(SEPARATOR).map { |c| Card.load(c) }
      Hand.new *cards
    end
  end

  def self.dump(hand)
    hand.sort.map { |c| Card.dump(c) }.join(SEPARATOR)
  end

  def initialize(*cards)
    @cards = cards
  end
end
