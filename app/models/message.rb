class Message < ApplicationRecord
  belongs_to :game
  belongs_to :sender, class_name: "Player"
  
  validates_presence_of :subject, :content
  
  delegate :email, to: :sender, prefix: true
  delegate :email, to: :recipient, prefix: true
  
  def sent_by?(player)
    sender == player
  end
  
  def recipient
    sent_by?(game.explorer) ? game.earther : game.explorer
  end
end
