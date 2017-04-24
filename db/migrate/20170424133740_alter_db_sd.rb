class AlterDbSd < ActiveRecord::Migration[5.0]
  def change
  	remove_column :deliver_categories , :deliverable_id
  end
end
