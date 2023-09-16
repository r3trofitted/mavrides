class Message < ApplicationRecord
  belongs_to :sender, class_name: "Character"
  belongs_to :round
  belongs_to :game
  
  delegate :role, to: :sender, prefix: true
  
  validates_uniqueness_of :sender_id, scope: :round_id
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
