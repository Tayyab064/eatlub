class AddFieldToOrder < ActiveRecord::Migration[5.0]
  def change
  	add_column :orders , :assigned , :datetime
  	add_column :orders , :tip , :float , default: 0.0
  end
end
