class Round < ApplicationRecord
  belongs_to :game

  serialize :earther_event, coder: Card
  serialize :explorer_event, coder: Card

  serialize :earther_hand, coder: Hand, type: Hand
  serialize :explorer_hand, coder: Hand, type: Hand

  after_initialize do
    if number == 1
      self.earther_hand  = Card.one_of_each_suit if earther_hand.empty?
      self.explorer_hand = Card.one_of_each_suit if explorer_hand.empty?
    end
  end

  def earther_hand=(value)
    value = Hand.new(*value) if value.kind_of? Array

    super(value)
  end

  def explorer_hand=(value)
    value = Hand.new(*value) if value.kind_of? Array

    super(value)
  end

  def next
    Round.new(
      game: game,
      number: number + 1,
      earther_hand: fill_hand(:earther),
      explorer_hand: fill_hand(:explorer)
    )
  end

  def fill_hand(kind)
    event = public_send :"#{kind}_event"
    hand  = public_send :"#{kind}_hand"

    hand.concat Card::VALUES.sample(2).map { |v| Card.new value: v, suit: event.suit }
  end
end
