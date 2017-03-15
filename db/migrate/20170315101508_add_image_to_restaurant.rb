class AddImageToRestaurant < ActiveRecord::Migration[5.0]
  def change
  	add_column :restaurants , :cover , :string
  end
end
