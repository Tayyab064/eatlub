class CreateDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :details do |t|
      t.boolean :online , default: true
      t.integer :status , default: 0
      t.string :city
      t.integer :vehicle
      t.integer :rider_id
      t.timestamps
    end
  end
end
