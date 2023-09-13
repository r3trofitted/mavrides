class Player < ApplicationRecord
  has_many :games
  
  normalizes :email, with: -> (email) { email.strip.downcase }
end
