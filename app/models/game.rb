class Game < ApplicationRecord
  with_options class_name: "Character" do
    has_one :earther, -> { earther }
    has_one :explorer, -> { explorer }
  end

  with_options source: :player do
    has_one :earther_player, through: :earther
    has_one :explorer_player, through: :explorer
  end

  has_many :messages

  enum :status, %i(pending running ended), default: :pending

  validates_presence_of :earther, :explorer
end
