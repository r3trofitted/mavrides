class Message < ApplicationRecord
  belongs_to :game
  belongs_to :sender, class_name: "Player"

  delegate :email, to: :sender, prefix: true
  delegate :email, to: :recipient, prefix: true

  def recipient
    sender == game.explorer_player ? game.earther_player : game.explorer_player
  end
end
