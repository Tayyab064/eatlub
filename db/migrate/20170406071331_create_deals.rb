class CreateDeals < ActiveRecord::Migration[5.0]
  def change
    create_table :deals do |t|
      t.datetime :avaliable
      t.integer :total_order , default: 1
      t.integer :order , default: 0
      t.float :discount , default: 1.0
      t.references :restaurant
      t.timestamps
    end
  end
end
