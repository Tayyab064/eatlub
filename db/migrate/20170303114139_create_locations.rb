class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.float :latitude
      t.float :longitude
      t.string :address , default: ""
      t.integer :rider_id
      t.timestamps
    end
  end
end
