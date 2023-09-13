class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.integer :earther_id, foreign_key: { to_table: :players }
      t.integer :explorer_id, foreign_key: { to_table: :players }

      t.timestamps
    end
  end
end
