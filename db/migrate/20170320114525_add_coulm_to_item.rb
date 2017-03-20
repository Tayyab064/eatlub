class AddCoulmToItem < ActiveRecord::Migration[5.0]
  def change
  	add_column :items , :ingredients, :integer , array: true, default: []
  	add_column :items , :option, :integer
  end
end
