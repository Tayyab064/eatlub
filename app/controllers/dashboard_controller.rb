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
		end
		redirect_to dashboard_end_users_path
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
end
