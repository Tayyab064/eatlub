class AddColumnToDeliverCategory < ActiveRecord::Migration[5.0]
  def change
  	add_column :deliver_categories , :image , :string
  end
end
