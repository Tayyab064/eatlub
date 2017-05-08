class Restaurant < ApplicationRecord
	belongs_to :owner, class_name: 'User'

	mount_uploader :image, ImageUploader
	mount_uploader :cover, ImageUploader
	
	geocoded_by :location do |obj,results|
	  if geo = results.first
	    obj.latitude    = geo.latitude
	    obj.longitude    = geo.longitude
	  end
	end
	after_validation :geocode 


	has_one :menu , :as => :menuable , dependent: :destroy
	has_many :reviews , :as => :reviewable , dependent: :destroy
	has_many :orders , :as => :ordera  , dependent: :destroy
	has_one :deal , dependent: :destroy

	enum status: [:pending , :approved , :block]
	enum order_status: [:quiet , :moderate , :busy]

	scope :approved, lambda {where(:status => 'approved')}
	scope :popular, lambda {where(:popular => true)}

	scope :highest_rated, lambda {where("restaurants.id in (select id from restaurants)").group('restaurants.id').joins(:reviews).order('AVG(reviews.rating) DESC')}

	def self.to_csv(options = {})
	  CSV.generate(options) do |csv|
	    csv << column_names
	    all.each do |restaurant|
	      csv << restaurant.attributes.values_at(*column_names)
	    end
	  end
	end

end
