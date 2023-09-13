class Message < ApplicationRecord
  belongs_to :game
  belongs_to :sender, class_name: "Player"
  
  delegate :email, to: :sender, prefix: true
  delegate :email, to: :recipient, prefix: true
  
  def recipient
    sender == game.explorer ? game.earther : game.explorer
  end
end
