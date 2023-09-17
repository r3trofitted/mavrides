class AddStatusToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :status, :integer, null: false, default: 0
  end
end
