class Restaurant < ApplicationRecord
	belongs_to :owner, class_name: 'User'
	geocoded_by :location
	has_one :menu , dependent: :destroy
end
