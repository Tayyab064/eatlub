class AddOrderStatusToRestaurant < ActiveRecord::Migration[5.0]
  def change
  	add_column :restaurants , :order_status , :integer , default: 0
  end
end
