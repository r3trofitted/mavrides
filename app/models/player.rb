class Player < ApplicationRecord
  has_many :characters

  encrypts :email, deterministic: true, downcase: true

  validates_presence_of :name, :email

  scope :participating_in, ->(game) { joins(:characters).merge Character.participating_in(game) }
end
