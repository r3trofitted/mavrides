class Character < ApplicationRecord
  belongs_to :player
  belongs_to :game

  enum :role, %i(earther explorer), validate: true
end
