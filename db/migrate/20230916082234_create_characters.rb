class CreateCharacters < ActiveRecord::Migration[7.1]
  def change
    create_table :characters do |t|
      t.references :player, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true
      t.string :name, null: false
      t.string :role, null: false

      t.timestamps
    end

    remove_foreign_key "messages", "players", column: "sender_id"
    add_foreign_key "messages", "characters", column: "sender_id"
  end
end
