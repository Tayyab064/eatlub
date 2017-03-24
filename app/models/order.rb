class Order < ApplicationRecord
	belongs_to :restaurant
    belongs_to :user

    has_many :items , dependent: :destroy
    enum status: [:pending , :approved , :dispatched , :arrived_restaurant , :arrived_user , :finish , :completed , :cancel]

    after_create :dashboard_noti

	def dashboard_noti
		Pusher.trigger('my-channel', 'my-event', {
		  message: 'hello world'
		})
	end
end
