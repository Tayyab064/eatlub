class MenuPolymorphic < ActiveRecord::Migration[5.0]
  def change
  	remove_column :menus , :restaurant_id , :integer

  	add_column :menus , :menuable_id , :integer
  	add_column :menus , :menuable_type , :string
  end
end
