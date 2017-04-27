class PloymorohicForOrderReview < ActiveRecord::Migration[5.0]
  def change
  	remove_column :reviews , :restaurant_id , :integer
  	remove_column :orders , :restaurant_id , :integer

  	add_column :reviews , :reviewable_id , :integer
  	add_column :reviews , :reviewable_type , :string

  	add_column :orders , :ordera_id , :integer
  	add_column :orders , :ordera_type , :string
  end
end
