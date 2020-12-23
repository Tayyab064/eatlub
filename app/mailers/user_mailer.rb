class UserMailer < ApplicationMailer

	def set_password(user)
		@user = user
    	@url  = 'http://138.197.117.248/owner/index'
    	mail(to: @user.email, subject: 'EatLub' )
	end

	def forget_password(user)
		@user = user
    	@url  = 'http://138.197.117.248/'
    	mail(to: @user.email, subject: 'EatLub' )
	end

	def restaurant_registered(user)
		@user = user
    	@url  = 'http://138.197.117.248/owner/index'
    	mail(to: @user.email, subject: 'EatLub' )
	end

	def userreg(user)
		@user = user
    	@url  = 'http://138.197.117.248/'
    	mail(to: @user.email, subject: 'EatLub' )
	end

	def usersignup(user)
		@user = user
    	@url  = 'http://138.197.117.248/'
    	mail(to: @user.email, subject: 'EatLub')
	end

	def restapprove(rest)
		@user = rest.owner
		@restaurant = rest
    	@url  = 'http://138.197.117.248/'
    	mail(to: @user.email, subject: 'EatLub')
	end

	def approverider(user)
		@user = user
    	@url  = 'http://138.197.117.248/'
    	mail(to: @user.email, subject: 'EatLub' )
	end

	def ordercheckout(order)
		@user = order.user
		@order = order
    	@url  = 'http://138.197.117.248/'
    	mail(to: @user.email, subject: 'EatLub')
	end

	def orderdelivery(order)
		@user = order.user
		@order = order
    	@url  = 'http://138.197.117.248/'
    	mail(to: @user.email, subject: 'EatLub')
	end
end
