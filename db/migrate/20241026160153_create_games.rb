class CreateGames < ActiveRecord::Migration[8.1]
  def change
    create_table :games do |t|
      t.integer :status

      t.timestamps
    end
    add_index :games, :status

    add_reference :characters, :game, foreign_key: true, index: true
  end
end
