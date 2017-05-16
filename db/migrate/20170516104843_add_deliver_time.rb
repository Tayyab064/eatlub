class AddDeliverTime < ActiveRecord::Migration[5.0]
  def change
  	add_column :deliverables , :delivery_time , :integer , default: 30
  end
end