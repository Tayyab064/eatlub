class AlterDb < ActiveRecord::Migration[5.0]
  def change
  	add_column :restaurants , :image , :string , default: ''
  	add_column :food_items , :image , :string , default: ''
  	add_column :restaurants , :popular , :boolean , default: false
  	add_column :restaurants , :about_us , :string , default: ''
  	remove_column :users , :password , :string
  	add_column :users , :inpas , :string
  end
end
