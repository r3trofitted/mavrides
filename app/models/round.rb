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
      earther_hand: earther_hand | game.draw_pile_of(:earther, suit: earther_event.suit).sample(2),
      explorer_hand: explorer_hand | game.draw_pile_of(:explorer, suit: explorer_event.suit).sample(2)
    )
  end
end
