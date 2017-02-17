class CreateFoodItems < ActiveRecord::Migration[5.0]
  def change
    create_table :food_items do |t|
      t.string :name
      t.float :price
      t.references :section

      t.timestamps
    end
  end
end
