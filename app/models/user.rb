class User < ApplicationRecord
	validates_uniqueness_of :email
	has_secure_password
	
	has_many :restaurants ,dependent: :destroy
	has_many :reviews , dependent: :destroy
	has_many :orders ,dependent: :destroy
	
	enum gender: [:male , :female]
	enum role: [:end_user , :restaurant_owner , :rider , :admin]
end
