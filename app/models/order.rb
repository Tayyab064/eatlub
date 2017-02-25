class Order < ApplicationRecord
	belongs_to :restaurant
    belongs_to :user

    has_many :items , dependent: :destroy
    enum status: [:pending , :approved , :dispatched , :completed , :cancel]
end
