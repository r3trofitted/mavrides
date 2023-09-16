class Player < ApplicationRecord
  has_many :characters
  has_many :games, through: :characters
  
  normalizes :email, with: -> (email) { email.strip.downcase }
end
