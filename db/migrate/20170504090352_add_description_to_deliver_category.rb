class AddDescriptionToDeliverCategory < ActiveRecord::Migration[5.0]
  def change
  	add_column :deliver_categories , :description , :string , default: ''
  end
end
