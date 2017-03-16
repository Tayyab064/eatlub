class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :address
      t.string :title
      t.references :user

      t.timestamps
    end
  end
end
