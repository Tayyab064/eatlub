class CreateWallets < ActiveRecord::Migration[5.0]
  def change
    create_table :wallets do |t|
      t.float :amount , default: 0.0
      t.references :user
      t.timestamps
    end
  end
end
