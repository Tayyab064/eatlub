class AddColumnToRestaurantAndFood < ActiveRecord::Migration[5.0]
  def change
  	add_column :restaurants , :commission , :float , default: 0.0
  	add_column :food_items , :publish , :boolean , default: true
  end
end
