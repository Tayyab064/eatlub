class Location < ApplicationRecord
	belongs_to :rider, class_name: 'User'

	reverse_geocoded_by :latitude, :longitude
	after_validation :reverse_geocode
end
