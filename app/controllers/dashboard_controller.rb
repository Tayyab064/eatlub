class DashboardController < ApplicationController
	before_action :is_admin , except: [:signin , :approve_signin]
	skip_before_action :verify_authenticity_token, :only => [:approve_signin , :signout]
	layout "dashboard_admin" , except: [:signin]

	def signin
		if session[:admin].present?
			redirect_to '/dashboard/index' , notice: 'Error: Already SiginedIn!'
		end
	end

	def approve_signin
		p params
		if admin = User.where(role: 3).find_by(email: params[:email]).try(:authenticate, params[:password]) 
			if admin.verified == true && admin.block == false
				if admin.inpas.present?
					admin.update(inpas: nil)
				end
				session[:admin] = params[:email]
				redirect_to '/dashboard/index' , notice: 'Successfully SignedIn!'
			else
				redirect_to :back , notice: 'Error: Dont have access to signin'
			end
		else
			redirect_to :back , notice: 'Error: Check Email/Password'
		end
	end

	def signout
		session[:admin] = nil
		redirect_to '/dashboard/signin' , notice: 'Successfully SignedOut!'
	end

	def index

	end

	def restaurants
		@restaurant = Restaurant.all
	end

	def end_user
		@user = User.where(role: 0)
	end

	def set_password_user
		user = User.find(params[:format])
		if params[:password].length > 8 && params[:password].length < 16
			user.update(password: params[:password] , inpas: params[:password] , verified: true)
			UserMailer.set_password(user).deliver_now
			redirect_to :back , notice: 'Successfully Verified'
		else
			redirect_to :back , notice: 'Error: Check password length'
		end
	end

	def unblock_user
		user = User.find(params[:format])
		user.update(block: false)
		redirect_to dashboard_end_users_path , notice: 'Successfully Unblocked'
	end

	def block_user
		user = User.find(params[:format])
		user.update(block: true)
		redirect_to dashboard_end_users_path , notice: 'Successfully Blocked'
	end

	def restaurant_owner
		@user = User.where(role: 1)
	end

	def rider
		@user = User.where(role: 2)
	end

	def admin
		@user = User.where(role: 3)
	end

	def rest_mark_approved
		restaurant = Restaurant.find(params[:id])
		restaurant.update(status: 1)
		unless restaurant.owner.password.present?
			#ow = restaurant.owner
			#ow.update(password: SecureRandom.urlsafe_base64(6))
			#UserMailer.set_password(ow).deliver_later
		end
		redirect_to dashboard_restaurants_path , notice: 'Successfully Approved'
	end

	def rest_mark_popular
		restaurant = Restaurant.find(params[:id])
		restaurant.update(popular: !restaurant.popular)
		redirect_to dashboard_restaurants_path , notice: 'Successfully Done'
	end

	def set_commission
		restaurant = Restaurant.find(params[:id])
		restaurant.update(commission: params[:commission])
		redirect_to dashboard_restaurants_path , notice: 'Successfully Done'
	end

	def block_restaurant
		restaurant = Restaurant.find(params[:id])
		restaurant.update(status: 2)
		redirect_to dashboard_restaurants_path , notice: 'Successfully Blocked'
	end

	def unblock_restaurant
		restaurant = Restaurant.find(params[:id])
		restaurant.update(status: 1)
		redirect_to dashboard_restaurants_path , notice: 'Successfully Unblocked'
	end

	def rider_orders
		@orders = Order.where(rider_id: params[:id])
		@total = 0.0
		@today = 0.0
		@month = 0.0
		order = @orders.where(status: 'completed')
		order.each do |se|
			@total = @total + se.restaurant.delivery_fee
		end
		order.where("created_at >= ?", Time.zone.now.beginning_of_day).each do |se|
			@today = @today + se.restaurant.delivery_fee
		end
		order.where("created_at >= ?", Time.now.beginning_of_month).each do |se|
			@month = @month + se.restaurant.delivery_fee
		end
	end

	def user_orders
		@orders = User.find(params[:id]).orders
	end

	def wallet
		@wallet = Wallet.all
	end

	def give_credit
		c = params[:user].split('EU')[1]
		if user = User.find_by_id(c)
			amo = user.wallet.amount + params[:amount].to_i
			user.wallet.update(amount: amo)
			redirect_to user_wallets_path , notice: 'Successfully wallet updated'
		else
			redirect_to user_wallets_path , notice: 'Error: Invalid User ID'
		end
	end
end
