class AddFieldToRestaurant < ActiveRecord::Migration[5.0]
  def change
  	add_column :restaurants , :post_code , :string
  	add_column :restaurants , :weekly_order , :integer , default: 0
  	add_column :restaurants , :no_of_location , :string
  	add_column :restaurants , :delivery , :boolean , default: false
  	add_column :restaurants , :delivery_fee , :float , default: 0.0
  end
end
