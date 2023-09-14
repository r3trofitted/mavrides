class Game < ApplicationRecord
  belongs_to :earther, class_name: "Player"
  belongs_to :explorer, class_name: "Player"
  
  has_many :rounds, -> { order(number: :asc) } do
    def current
      last
    end
  end
  has_many :messages, after_add: :update_rounds
  
  def players
    [earther, explorer]
  end
  
  def update_rounds(message)
    if message.sent_by?(explorer)
      if rounds.any?
        rounds.current.next.save!
      else
        rounds.create! number: 1
      end
    end
  end
end
