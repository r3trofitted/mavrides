class AddMessagesToRounds < ActiveRecord::Migration[7.1]
  def change
    add_reference :messages, :round, foreign_key: true
    add_index :messages, [:round_id, :sender_id], unique: true
  end
end
