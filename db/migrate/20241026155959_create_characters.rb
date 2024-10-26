class CreateCharacters < ActiveRecord::Migration[8.1]
  def change
    create_table :characters do |t|
      t.string :name
      t.integer :role
      t.references :player, null: false, foreign_key: true

      t.timestamps
    end
  end
end
