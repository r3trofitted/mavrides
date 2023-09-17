class Game < ApplicationRecord
  has_one :earther, -> { where role: "earther" }, class_name: "Character"
  has_one :explorer, -> { where role: "explorer" }, class_name: "Character"
  
  has_many :rounds, -> { order(number: :asc) } do
    def current
      last
    end
  end
  has_many :messages, before_add: :set_round, after_add: [:update_rounds, :transmit_message] # TODO: validate coherence of the message's round
  
  enum :status, %i(pending started ended), default: :pending
  
  def characters
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
  
  def set_round(message)
    message.round ||= rounds.current
  end
  
  def update_rounds(message)
    rounds.current.next.save! if message.sent_by?(earther)
  end
  
  def events(character: nil, suit: nil)
    if character
      rounds
        .map    { |r| r.event_for(character) }
        .reject { |e| e.suit != suit }
    else
      events(character: earther, suit:).concat events(character: explorer, suit:)
    end
  end
  
  def transmit_message(message)
    throw(:abort) if message.invalid?
    
    MessagesMailer.with(message:).transmission.deliver_later
  end
  
  # TODO: receive a Player object instead of a role as 1st argument
  def draw_pile_of(role, suit:)
    raise ArgumentError unless role.in? %i(earther explorer)
    
    played_values = events(character: send(role)).map(&:value)
    (Card::VALUES - played_values).map { |v| Card.new value: v, suit: suit }
  end
end
