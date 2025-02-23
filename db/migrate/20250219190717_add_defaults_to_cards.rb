class AddDefaultsToCards < ActiveRecord::Migration[8.0]
  def up
    change_column_default :cards, :quantity, 0
    change_column_default :cards, :price, 0.0
    change_column_default :cards, :mana, ''
    change_column_default :cards, :description, 'No description available'
  end

  def down
  end
end
