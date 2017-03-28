class Option < ApplicationRecord
	belongs_to :food_item
	has_many :components , dependent: :destroy
end
