class Restaurant < ApplicationRecord
	belongs_to :owner, class_name: 'User'
	
	geocoded_by :location
	after_validation :geocode 

	has_one :menu , dependent: :destroy

	enum status: [:pending , :approved]
end
