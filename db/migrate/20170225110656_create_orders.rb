class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :address , default: ''
      t.string :notes , default: ''
      t.integer :status , default: 0
      t.references :restaurant
      t.references :user
      t.integer :rider_id
      t.timestamps
    end
  end
end
