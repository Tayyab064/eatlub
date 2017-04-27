class Menu < ApplicationRecord
	belongs_to :menuable, :polymorphic => true
	has_many :sections , dependent: :destroy
end
