class ReplaceRoleByEnumInCharacters < ActiveRecord::Migration[7.2]
  def change
    reversible do |direction|
      change_table :characters do |t|
        direction.up   { t.change :role, :integer }
        direction.down { t.change :role, :string }
      end
    end
  end
end
