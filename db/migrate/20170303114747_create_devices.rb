class CreateDevices < ActiveRecord::Migration[5.0]
  def change
    create_table :devices do |t|
      t.string :token
      t.string :device , default: 'Android' 
      t.references :user
      t.timestamps
    end
  end
end
