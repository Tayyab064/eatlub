class Review < ApplicationRecord
	belongs_to :reviewable, :polymorphic => true
	belongs_to :reviewer, class_name: 'User'

	after_create :rati

	def rati
		self.rating = ((self.quality + self.price + self.punctuality + self.courtesy ).to_f / 4).round
		self.save
	end
end
