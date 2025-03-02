class AddGathererIdToCardSets < ActiveRecord::Migration[8.0]
  def change
    add_column :card_sets, :gatherer_id, :integer, null: true
    add_index :card_sets, :gatherer_id, unique: true
  end
end
