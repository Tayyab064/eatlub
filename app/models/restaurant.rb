class Restaurant < ApplicationRecord
	belongs_to :owner, class_name: 'User'

	mount_uploader :image, ImageUploader
	mount_uploader :cover, ImageUploader
	
	geocoded_by :location
	after_validation :geocode 

	has_one :menu , dependent: :destroy
	has_many :reviews , dependent: :destroy
	has_many :orders , dependent: :destroy

	enum status: [:pending , :approved , :block]

	scope :approved, lambda {where(:status => 'approved')}
	scope :popular, lambda {where(:popular => true)}

end
