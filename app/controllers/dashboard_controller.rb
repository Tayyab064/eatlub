class DashboardController < ApplicationController

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
			user.update(password: params[:password])
			UserMailer.set_password(user).deliver_later
		end
		redirect_to :back
	end

	def unblock_user
		user = User.find(params[:format])
		user.update(block: false)
		redirect_to dashboard_end_users_path
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
		redirect_to dashboard_restaurants_path
	end
end
