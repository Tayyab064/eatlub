class CreateIngredients < ActiveRecord::Migration[5.0]
  def change
    create_table :ingredients do |t|
      t.string :title
      t.float :price , default: 0.0
      t.references :food_item
      t.timestamps
    end
  end
end
