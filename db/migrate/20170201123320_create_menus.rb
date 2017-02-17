class CreateMenus < ActiveRecord::Migration[5.0]
  def change
    create_table :menus do |t|
      t.string :title , default: 'Menu'
      t.references :restaurant

      t.timestamps
    end
  end
end
