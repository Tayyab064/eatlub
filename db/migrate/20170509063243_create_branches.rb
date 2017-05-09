class CreateBranches < ActiveRecord::Migration[5.0]
  def change
    create_table :branches do |t|
      t.string :address
      t.float :latitude
      t.float :longitude
      t.string :post_code
      t.references :deliverable
      t.timestamps
    end
  end
end
