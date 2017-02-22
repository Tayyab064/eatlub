class OwnerController < ApplicationController
	before_action :is_owner , except: [:signin , :approve_signin]
	skip_before_action :verify_authenticity_token, :only => [:approve_signin]
	layout "dashboard_owner" , except: [:signin]

	def signin
		if session[:owner].present?
			redirect_to '/owner/index'
		end
	end

	def approve_signin
		p params
		if owner = User.where(role: 1).where(verified: true).find_by(email: params[:email]).try(:authenticate, params[:password]) 
			if owner.verified == true && owner.block == false
				session[:owner] = params[:email]
				redirect_to '/owner/index'
			else
				redirect_to :back
			end
		else
			redirect_to :back
		end
	end

	def index

	end

	def restaurants
		@restaurant = Restaurant.all
	end

	def restaurant_menu_add
		@restaurant = Restaurant.find(params[:id])
	end
end
