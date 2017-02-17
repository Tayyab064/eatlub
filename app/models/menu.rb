class Menu < ApplicationRecord
	belongs_to :restaurant
	has_many :sections , dependent: :destroy
end
