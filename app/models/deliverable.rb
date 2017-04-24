class Deliverable < ApplicationRecord
	belongs_to :owner, class_name: 'User'

	mount_uploader :image, ImageUploader
	mount_uploader :cover, ImageUploader
	
	geocoded_by :location do |obj,results|
	  if geo = results.first
	    obj.latitude    = geo.latitude
	    obj.post_code = geo.postal_code
	    obj.longitude    = geo.longitude
	  end
	end
	after_validation :geocode 

	enum status: [:pending , :approved , :block]
	enum order_status: [:quiet , :moderate , :busy]

	has_one :deliver_category , dependent: :destroy

	scope :approved, lambda {where(:status => 'approved')}
	scope :popular, lambda {where(:popular => true)}

end
