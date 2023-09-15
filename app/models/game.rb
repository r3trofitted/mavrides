class Game < ApplicationRecord
  with_options class_name: "Character" do
    has_one :earther, -> { earther }
    has_one :explorer, -> { explorer }
  end

  with_options source: :player do
    has_one :earther_player, through: :earther
    has_one :explorer_player, through: :explorer
  end

  has_many :rounds, -> { order(number: :asc) } do
    def current
      last
    end
  end
  has_many :messages, after_add: [:update_rounds, :transmit_message]

  enum :status, %i(pending running ended), default: :pending

  validates_presence_of :earther, :explorer

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
    rounds.current.next.save! if message.sent_by? earther_player
  end

  def transmit_message(message)
    throw(:abort) if message.invalid?

    table    = rounds.current.earther_event.suit
    progress = send(:"#{message.sender == earther ? 'earther' : 'explorer'}_events").count { |e| e.suit == table }

    MessagesMailer.with(message:).transmission(event_prompt: :"#{table}_#{progress}").deliver_later
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
