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
  
  def events(player: nil, suit: nil)
    if player
      role = (player == earther) ? :earther : :explorer
      rounds.map(&:"#{role}_event").reject { |e| e.suit != suit }
    else
      events(player: earther, suit:).concat events(player: explorer, suit:)
    end
  end
  
  def transmit_message(message)
    throw(:abort) if message.invalid?
    
    MessagesMailer.with(message:).transmission.deliver_later
  end
  
  # TODO: receive a Player object instead of a role as 1st argument
  def draw_pile_of(role, suit:)
    raise ArgumentError unless role.in? %i(earther explorer)
    
    played_values = events(player: send(role)).map(&:value)
    (Card::VALUES - played_values).map { |v| Card.new value: v, suit: suit }
  end
end
