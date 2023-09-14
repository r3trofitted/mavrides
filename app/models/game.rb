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

    def next!
      create!(number: current&.number.to_i + 1)
    end
  end
  has_many :messages, after_add: :update_rounds

  enum :status, %i(pending running ended), default: :pending

  validates_presence_of :earther, :explorer

  def update_rounds(message)
    rounds.next! if message.sent_by? explorer_player
  end
end
