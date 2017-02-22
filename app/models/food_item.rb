class FoodItem < ApplicationRecord
	belongs_to :section
	mount_uploader :image, ImageUploader
end
