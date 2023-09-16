class Character < ApplicationRecord
  belongs_to :player
  belongs_to :game
  
  validates_inclusion_of :role, in: %(earther explorer)
  
  delegate :email, to: :player, prefix: true
end
