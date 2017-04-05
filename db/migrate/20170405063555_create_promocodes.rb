class CreatePromocodes < ActiveRecord::Migration[5.0]
  def change
    create_table :promocodes do |t|
      t.string :promocode
      t.float :amount , default: 1.0
      t.boolean :used , default: false
      t.integer :usedby
      t.timestamps
    end
  end
end
