class AddPartnerFieldInDeliverable < ActiveRecord::Migration[5.0]
  def change
  	add_column :deliverables , :partner , :boolean , default: false
  end
end
