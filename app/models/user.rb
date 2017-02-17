class User < ApplicationRecord
	validates_uniqueness_of :email
	has_many :restaurants ,dependent: :destroy

	enum gender: [:male , :female]
	enum role: [:end_user , :restaurant_owner , :rider , :admin]
end
