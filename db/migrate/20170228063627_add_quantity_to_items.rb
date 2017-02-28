class AddQuantityToItems < ActiveRecord::Migration[5.0]
  def change
  	add_column :items , :quantity , :integer , default: 0
  end
end
