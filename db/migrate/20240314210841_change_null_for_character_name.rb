class ChangeNullForCharacterName < ActiveRecord::Migration[7.2]
  def change
    change_column_null :characters, :name, true, "[unknown]"
  end
end
