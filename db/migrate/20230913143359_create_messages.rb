class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.references :game, null: false, foreign_key: true
      t.references :sender, null: false, foreign_key: { to_table: :players }
      t.string :subject
      t.text :content

      t.timestamps
    end
  end
end
