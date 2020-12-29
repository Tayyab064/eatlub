class UserMailer < ApplicationMailer

	def set_password(user)
		@user = user
    	@url  = 'https://eatlbo.herokuapp.com/owner/index'
    	mail(to: @user.email, subject: 'EatLub' )
	end

	def forget_password(user)
		@user = user
    	@url  = 'https://eatlbo.herokuapp.com/'
    	mail(to: @user.email, subject: 'EatLub' )
	end

	def restaurant_registered(user)
		@user = user
    	@url  = 'https://eatlbo.herokuapp.com/owner/index'
    	mail(to: @user.email, subject: 'EatLub' )
	end

	def userreg(user)
		@user = user
    	@url  = 'https://eatlbo.herokuapp.com/'
    	mail(to: @user.email, subject: 'EatLub' )
	end

	def usersignup(user)
		@user = user
    	@url  = 'https://eatlbo.herokuapp.com/'
    	mail(to: @user.email, subject: 'EatLub')
	end

	def restapprove(rest)
		@user = rest.owner
		@restaurant = rest
    	@url  = 'https://eatlbo.herokuapp.com/'
    	mail(to: @user.email, subject: 'EatLub')
	end

	def approverider(user)
		@user = user
    	@url  = 'https://eatlbo.herokuapp.com/'
    	mail(to: @user.email, subject: 'EatLub' )
	end

	def ordercheckout(order)
		@user = order.user
		@order = order
    	@url  = 'https://eatlbo.herokuapp.com/'
    	mail(to: @user.email, subject: 'EatLub')
	end

	def orderdelivery(order)
		@user = order.user
		@order = order
    	@url  = 'https://eatlbo.herokuapp.com/'
    	mail(to: @user.email, subject: 'EatLub')
	end
end
