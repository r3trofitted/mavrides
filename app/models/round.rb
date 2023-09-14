class Round < ApplicationRecord
  belongs_to :game
  
  after_initialize do
    if number == 1
      self.earther_hand ||= Card.new_hand
      self.explorer_hand ||= Card.new_hand
    end
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
    Card.new_hand # SLIME
  end
end
