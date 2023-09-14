class Round < ApplicationRecord
  belongs_to :game

  after_initialize do
    if number == 1
      self.earther_hand ||= Card.new_hand
      self.explorer_hand ||= Card.new_hand
    end
  end
end
