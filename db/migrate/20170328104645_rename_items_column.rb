class RenameItemsColumn < ActiveRecord::Migration[5.0]
  def change
  	remove_column :items , :option , :integer
  	add_column :items , :option, :integer , array: true, default: []
  end
end
