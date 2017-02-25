class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.references :order
      t.string :orderable_type
      t.integer :orderable_id
      t.timestamps
    end
  end
end
