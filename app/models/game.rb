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
  has_many :messages, after_add: :update_rounds

  enum :status, %i(pending running ended), default: :pending

  validates_presence_of :earther, :explorer

  def starts
    # FIXME: don't start twice!
    # FIXME: rename to starts! since this method is significant enough to potentially raise

    save! if new_record?
    rounds.create! number: 1
  end

  def update_rounds(message)
    rounds.current.next.save! if message.sent_by? explorer
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
