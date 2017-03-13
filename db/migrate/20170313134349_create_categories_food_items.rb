class CreateCategoriesFoodItems < ActiveRecord::Migration[5.0]
  def change
    create_table :categories_food_items do |t|
    	t.belongs_to :category, index: true
    	t.belongs_to :food_item, index: true
    end
  end
end