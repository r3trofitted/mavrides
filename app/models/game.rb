class Game < ApplicationRecord
  belongs_to :earther, class_name: "Player"
  belongs_to :explorer, class_name: "Player"
  
  has_many :rounds, -> { order(number: :asc) } do
    def current
      last
    end
    
    def next!
      create!(number: current&.number.to_i + 1)
    end
  end
  has_many :messages, after_add: :update_rounds
  
  def players
    [earther, explorer]
  end
  
  def update_rounds(message)
    rounds.next! if message.sent_by?(explorer)
  end
end
