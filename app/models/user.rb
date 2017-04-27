class User < ApplicationRecord
	validates_uniqueness_of :email
	#validates_uniqueness_of :mobile_number
	has_secure_password

	has_secure_token :token
	has_secure_token :password_reset_token
	
	has_many :restaurants , foreign_key: "owner_id" ,dependent: :destroy
	has_many :deliverables , foreign_key: "owner_id" ,dependent: :destroy
	has_many :reviews , foreign_key: "reviewer_id" , dependent: :destroy
	has_many :orders ,dependent: :destroy
	has_one :location , foreign_key: "rider_id" , dependent: :destroy
	has_one :detail , foreign_key: "rider_id" , dependent: :destroy
	has_many :devices , dependent: :destroy
	has_many :addresses , dependent: :destroy
	has_one :wallet , dependent: :destroy
	
	enum gender: [:male , :female]
	enum role: [:end_user , :restaurant_owner , :rider , :admin]

	def self.to_csv(options = {})
	  cd = ["name","username","email","gender","mobile_number"]
	  CSV.generate(options) do |csv|
	    csv << cd
	    all.each do |user|
	      csv << user.attributes.values_at(*cd)
	    end
	  end
	end
end
