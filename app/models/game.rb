class Game < ApplicationRecord
  belongs_to :earther, class_name: "Player"
  belongs_to :explorer, class_name: "Player"
end