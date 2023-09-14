class Message < ApplicationRecord
  belongs_to :game
  belongs_to :sender, class_name: "Player"

  delegate :email, to: :sender, prefix: true
  delegate :email, to: :recipient, prefix: true

  def recipient
    if sent_by? game.explorer_player
      game.earther_player
    else
      game.explorer_player
    end
  end

  def sent_by?(player)
    sender == player
  end
end
