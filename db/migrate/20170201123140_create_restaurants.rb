class CreateRestaurants < ActiveRecord::Migration[5.0]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.datetime :opening_time
      t.datetime :closing_time
      t.string :location
      t.string :cuisine
      t.string :typee
      t.integer :owner_id

      t.timestamps
    end
  end
end
