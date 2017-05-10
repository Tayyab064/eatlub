class RemoveLatLongPostcodeFromDeliverable < ActiveRecord::Migration[5.0]
  def change
  	remove_column :deliverables , :location , :string
  	remove_column :deliverables , :latitude , :float
  	remove_column :deliverables , :longitude , :float
  	remove_column :deliverables , :post_code , :string
  end
end
