class Character < ApplicationRecord
  belongs_to :player
  
  enum :role, %i(earther explorer), validate: true
end
