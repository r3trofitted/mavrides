class Message < ApplicationRecord
  belongs_to :game
  belongs_to :sender, class_name: "Character"
  
  validates_presence_of :subject, :content
  
  def sent_by?(character)
    sender == character
  end
  
  def sender_email
    sender.player_email
  end
  
  def recipient_email
    recipient.player_email
  end
  
  def recipient
    sent_by?(game.explorer) ? game.earther : game.explorer
  end
end
