class CreatePrices < ActiveRecord::Migration[5.0]
  def change
    create_table :prices do |t|
      t.float :start_km , default: 0.0
      t.float :end_km , default: 0.0
      t.float :price , default: 0.0
      t.timestamps
    end
  end
end
