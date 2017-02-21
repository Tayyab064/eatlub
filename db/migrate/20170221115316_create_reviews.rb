class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.string :summary , default: ''
      t.integer :rating , default: 1
      t.integer :quality , default: 1
  	  t.integer :price , default: 1
  	  t.integer :punctuality , default: 1
  	  t.integer :courtesy , default: 1
  	  t.references :restaurant
      t.integer :reviewer_id
      t.timestamps
    end
  end
end
