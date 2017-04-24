class CreateDeliverCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :deliver_categories do |t|
      t.string :name
      t.references :deliverable
      t.timestamps
    end
  end
end
