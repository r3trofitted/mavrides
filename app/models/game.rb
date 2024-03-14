class Game < ApplicationRecord
  has_one :earther, -> { earther }, class_name: "Character"
  has_one :explorer, -> { explorer }, class_name: "Character"
  has_one :earther_player, through: :earther, source: :player
  has_one :explorer_player, through: :explorer, source: :player

  has_many :rounds, -> { order(number: :asc) } do
    def current
      last
    end
  end

  # OPTIMIZE: this is at the core of the game loop. Maybe it should be in its own model, instead of existing only as callbacks?
  # TODO: validate coherence of the message's round
  has_many :messages, before_add: :set_round, after_add: [:update_rounds, :transmit_message]

  enum :status, %i(pending started ended), default: :pending

  validates_presence_of :earther, :explorer
  validates_absence_of :rounds, on: :game_start

  delegate :name, to: :earther, prefix: true
  delegate :name, to: :explorer, prefix: true

  accepts_nested_attributes_for :earther, :explorer, update_only: true

  def self.prepare(earther_player:, explorer_player:, earther_name: nil, explorer_name: nil)
    pending_games = pending.played_by(as_earther: earther_player, as_explorer: explorer_player)
    # TODO: error if more than 1 (“+sole_if_exists+”)

    if game = pending_games.first
      game.update earther_attributes: { name: earther_name }.compact_blank!,
                  explorer_attributes: { name: explorer_name }.compact_blank!
    else
      game = create earther_attributes: { name: earther_name, player: earther_player },
                    explorer_attributes: { name: explorer_name, player: explorer_player }
    end

    game
  end

  def self.played_by(as_earther:, as_explorer:)
    self
      .joins(:earther_player, :explorer_player)
      .where(earther_player: { id: as_earther.id }, explorer_player: { id: as_explorer.id })
  end

  def characters
    [earther, explorer]
  end

  def ready_to_start?
    pending? && valid?(:game_start)
  end

  def starts!
    raise "Game already started" if started?

    rounds << Round.build_first(game: self)
    started!

    GameMailer.with(game: self).game_starts_for_explorer.deliver_later
    GameMailer.with(game: self).game_starts_for_earther.deliver_later
  end

  def set_round(message)
    message.round ||= rounds.current
  end

  def update_rounds(message)
    if message.final?
      ended!
    elsif message.sent_by? earther
      if at_least_one_major_event_table_is_through?
        ended!
      else
        rounds.current.next!
      end
    end
  end

  # TODO: change :suit argument to :suits to allow filtering on more than one suit
  def events_for(character, suit: nil)
    filtered_suits = suit ? [suit] : Card::SUITS

    rounds
      .filter_map { |r| r.event_for character }
      .filter { |r| r.suit.in? filtered_suits }
  end

  def transmit_message(message)
    throw(:abort) if message.invalid?

    MessagesMailer.with(message:).transmission.deliver_later
  end

  # TODO: receive a Player object instead of a role as 1st argument
  def draw_pile_of(role, suit:)
    raise ArgumentError unless role.in? %i(earther explorer)

    player = send(role)
    played_values = events_for(player).map(&:value)

    (Card::VALUES - played_values).map { |v| Card.new value: v, suit: suit }
  end

  private

  # SMELL: we're doing too many acrobatics with primitives here. There must be some object or method waiting to emerge
  def at_least_one_major_event_table_is_through?
    all_events = [events_for(earther), events_for(explorer)]

    all_events
      .map { |es| es.map(&:suit).tally }
      .flat_map(&:values)
      .any? { |c| c > 4 }
  end
end
