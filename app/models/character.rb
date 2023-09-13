class Character < ApplicationRecord
  belongs_to :player
  belongs_to :game

  enum :role, %i(earther explorer), validate: true

  scope :participating_in, ->(game) { where(game: game) }
end
