class AddStatusToRestaurant < ActiveRecord::Migration[5.0]
  def change
  	add_column :restaurants , :status , :integer , default: 0
  end
end
