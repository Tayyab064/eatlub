class CreateDeliverables < ActiveRecord::Migration[5.0]
  def change
    create_table :deliverables do |t|
    	t.string :name
    	t.datetime :opening_time
    	t.datetime :closing_time
    	t.string :location
    	t.integer :owner_id
    	t.float :latitude
    	t.float :longitude
    	t.integer :status , default: 0
    	t.string :image , default: ""
    	t.boolean :popular , default: false
    	t.string :about_us , default: ""
    	t.string :post_code
    	t.integer :weekly_order , default: 0
    	t.string :no_of_location
    	t.boolean :delivery , default: false
    	t.float :delivery_fee , default: 0.0
    	t.float :commission , default: 0.0
    	t.string :cover
    	t.string :phone_number
    	t.string :close_day , default: [] , array: true
    	t.integer :order_status , default: 0
    	t.references :deliver_category
        t.timestamps
    end
  end
end
