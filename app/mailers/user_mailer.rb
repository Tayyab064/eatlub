class UserMailer < ApplicationMailer

	def set_password(user)
		@user = user
    	@url  = 'http://138.197.117.248/owner/index'
    	mail(to: @user.email, subject: 'Deliverush' )
	end

	def forget_password(user)
		@user = user
    	@url  = 'http://138.197.117.248/'
    	mail(to: @user.email, subject: 'Deliverush' )
	end

	def restaurant_registered(user)
		@user = user
    	@url  = 'http://138.197.117.248/owner/index'
    	mail(to: @user.email, subject: 'Deliverush' )
	end
end
