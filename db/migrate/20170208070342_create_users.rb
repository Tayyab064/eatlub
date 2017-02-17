class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
		t.string :name, default: ""
		t.string :username, default: ""
		t.string :email
		t.integer :gender
		t.string :password
		t.integer :role, default: 0
		t.boolean :verified, default: false
		t.boolean :block, default: false
		t.string :password_digest
		
      	t.timestamps
    end

    add_index :users, :role
    add_index :users, :email
  end
end
