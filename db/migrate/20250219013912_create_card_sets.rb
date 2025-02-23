class CreateCardSets < ActiveRecord::Migration[8.0]
  def change
    create_table :card_sets do |t|
      t.string :name

      t.timestamps
    end
  end
end
