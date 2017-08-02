class Order < ApplicationRecord
	belongs_to :ordera, :polymorphic => true
    belongs_to :user

    has_many :items , dependent: :destroy
    enum status: [:pending , :approved , :arrived_restaurant , :arrived_user , :finish , :completed , :cancel]

    after_create :dashboard_noti

	def dashboard_noti
		Pusher.trigger('my-channel', 'my-event', {
		  message: "Receieved new order:  O#{self.id}",
		  order_id: self.id
		})
	end

	scope :for_year, lambda {where("created_at >= ? and created_at <= ?", "#{Date.today.year}-01-01", "#{Date.today.year}-12-31")}

	def week
	self.created_at.strftime('%W')
	end

	def month
	self.created_at.strftime('%m')
	end

	def daily
	self.created_at.strftime('%d')
	end
end
