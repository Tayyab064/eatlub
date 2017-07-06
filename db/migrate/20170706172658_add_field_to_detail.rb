class AddFieldToDetail < ActiveRecord::Migration[5.0]
  def change
  	add_column :details , :family_name , :string
  	add_column :details , :address , :string
  	add_column :details , :postal_code , :string
  	add_column :details , :current_occupation , :string
  	add_column :details , :right_to_work , :string
  	add_column :details , :driving_licence , :boolean , default: false
  	add_column :details , :phone_device , :string
  	add_column :details , :worked_with_us , :boolean , default: false
  	add_column :details , :criminal_offence , :boolean , default: false
  end
end
