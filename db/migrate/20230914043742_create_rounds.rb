class CreateRounds < ActiveRecord::Migration[7.1]
  def change
    create_table :rounds do |t|
      t.references :game, null: false, foreign_key: true
      t.integer :number, null: false
      t.string :earther_event, limit: 8
      t.string :explorer_event, limit: 8
      t.string :earther_hand
      t.string :explorer_hand

      t.timestamps
    end

    add_index :rounds, [:game_id, :number], unique: true
  end
end
