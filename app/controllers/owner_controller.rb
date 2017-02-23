class OwnerController < ApplicationController
	before_action :is_owner , except: [:signin , :approve_signin]
	skip_before_action :verify_authenticity_token, :only => [:approve_signin]
	layout "dashboard_owner" , except: [:signin]

	def signin
		if session[:owner].present?
			redirect_to '/owner/index' , notice: 'Error: Already SignedIn!'
		end
	end

	def approve_signin
		if owner = User.where(role: 1).where(verified: true).find_by(email: params[:email]).try(:authenticate, params[:password]) 
			if owner.verified == true && owner.block == false
				session[:owner] = params[:email]
				redirect_to '/owner/index' , notice: 'Successfully SignedIn!'
			else
				redirect_to :back , notice: 'Error: Dont have access to signin!'
			end
		else
			redirect_to :back , notice: 'Error: Check Email/Password'
		end
	end

	def index

	end

	def restaurants
		@restaurant = Restaurant.all
	end

	def restaurant_menu_add
		@restaurant = Restaurant.find(params[:id])
		unless @restaurant.menu.present?
			Menu.create(title: 'Menu' , restaurant_id: @restaurant.id)
		end
	end

	def save_fooditem
		if params[:section].length > 0
			res = Restaurant.find(params[:restaurant_id])
			sec = Section.create(title: params[:section], menu_id: res.menu.id)
			sec_f = sec.id
		else
			sec_f = params[:menu_section].to_i
		end
		FoodItem.create(name: params[:name], price: params[:price], section_id: sec_f, image: params[:image])
		redirect_to :back , notice: 'Successfully Added!'
	end

	def restaurant_menu
		@restaurant = Restaurant.find(params[:id])
	end
end
