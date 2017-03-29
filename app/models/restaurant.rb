class Restaurant < ApplicationRecord
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


	has_one :menu , dependent: :destroy
	has_many :reviews , dependent: :destroy
	has_many :orders , dependent: :destroy

	enum status: [:pending , :approved , :block]
	enum order_status: [:quiet , :moderate , :busy]

	scope :approved, lambda {where(:status => 'approved')}
	scope :popular, lambda {where(:popular => true)}

	def self.to_csv(options = {})
	  CSV.generate(options) do |csv|
	    csv << column_names
	    all.each do |restaurant|
	      csv << restaurant.attributes.values_at(*column_names)
	    end
	  end
	end

end
