class AlterDatabase < ActiveRecord::Migration[5.0]
  def change
  	add_column :sections , :description , :string
  	add_column :food_items , :description , :string
  	add_column :restaurants , :phone_number , :string
  	add_column :restaurants , :close_day, :string , array: true, default: []
  end
end
