class CreateComponents < ActiveRecord::Migration[5.0]
  def change
    create_table :components do |t|
      t.string :title , default: ''
      t.float :price , default: 0.0
      t.references :option
      t.timestamps
    end
  end
end
