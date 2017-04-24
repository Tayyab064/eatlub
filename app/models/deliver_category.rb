class DeliverCategory < ApplicationRecord
	has_many :deliverables , dependent: :destroy

	mount_uploader :image, ImageUploader
end
