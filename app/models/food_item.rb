class FoodItem < ApplicationRecord
	belongs_to :section
	mount_uploader :image, ImageUploader

	has_many :items , :as => 'orderable' ,dependent: :destroy
	has_and_belongs_to_many :categories
end
