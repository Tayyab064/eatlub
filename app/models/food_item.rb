class FoodItem < ApplicationRecord
	belongs_to :section
	mount_uploader :image, ImageUploader

	has_many :items , :as => 'orderable' ,dependent: :destroy
end
