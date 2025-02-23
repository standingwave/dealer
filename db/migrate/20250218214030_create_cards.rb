class CreateCards < ActiveRecord::Migration[8.0]
  def change
    create_table :cards do |t|
      t.integer :quantity
      t.string :name
      t.string :condition
      t.string :card_type
      t.string :description
      t.string :color
      t.string :mana
      t.string :rarity
      t.decimal :price
      t.integer :card_set_id

      t.timestamps
    end
  end
end
