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
  
  def starts!
    raise "Game already started" if started?
    
    rounds << Round.build_first(game: self)
    save! if new_record?
    
    GameMailer.with(game: self).game_starts_for_explorer.deliver_later
    GameMailer.with(game: self).game_starts_for_earther.deliver_later
  end
  
  def started?
    rounds.any?
  end
  
  def update_rounds(message)
    rounds.current.next.save! if message.sent_by?(earther)
  end
  
  def earther_events
    rounds.filter_map(&:earther_event)
  end
  
  def explorer_events
    rounds.filter_map(&:explorer_event)
  end
  
  def draw_pile_of(role, suit:)
    played_values = public_send(:"#{role}_events").filter_map { |e| e.value if e.suit == suit }
    (Card::VALUES - played_values).map { |v| Card.new value: v, suit: suit }
  end
end
