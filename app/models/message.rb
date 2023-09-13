class Message < ApplicationRecord
  belongs_to :game
  belongs_to :sender, class_name: "Player"
end
