class AddGathererIdToCards < ActiveRecord::Migration[8.0]
  def change
    add_column :cards, :gatherer_id, :integer, null: true
    add_index :cards, :gatherer_id, unique: true
  end
end
