class Game < ApplicationRecord
  belongs_to :earther, class_name: "Player"
  belongs_to :explorer, class_name: "Player"
  
  has_many :rounds, -> { order(number: :asc) } do
    def current
      last
    end
  end
  has_many :messages, after_add: [:update_rounds, :transmit_message]
  
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
  
  def transmit_message(message)
    throw(:abort) if message.invalid?
    
    table    = rounds.current.earther_event.suit
    progress = send(:"#{message.sender == earther ? 'earther' : 'explorer'}_events", table).count
    
    MessagesMailer.with(message:).transmission(event_prompt: :"#{table}_#{progress}").deliver_later
  end
  
  def earther_events(suit = nil)
    rounds.filter_map(&:earther_event).reject { |r| r.suit != suit }
  end
  
  def explorer_events(suit = nil)
    rounds.filter_map(&:explorer_event).reject { |r| r.suit != suit }
  end
  
  def draw_pile_of(role, suit:)
    played_values = public_send(:"#{role}_events", suit).map(&:value)
    (Card::VALUES - played_values).map { |v| Card.new value: v, suit: suit }
  end
end
