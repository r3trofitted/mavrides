class Character < ApplicationRecord
  belongs_to :player
  belongs_to :game

  enum :role, %i(earther explorer), validate: true

  validates_presence_of :name, on: [:update, :game_start]

  delegate :email, to: :player, prefix: true
end
