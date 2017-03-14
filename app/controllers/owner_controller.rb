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
		@restaurant = @owner.restaurants
	end

	def restaurant_menu_add
		@restaurant = @owner.restaurants.find(params[:id])
		unless @restaurant.menu.present?
			Menu.create(title: 'Menu' , restaurant_id: @restaurant.id)
			redirect_to :back
		end
	end

	def save_fooditem
		if params[:section].length > 0
			res = @owner.restaurants.find(params[:restaurant_id])
			sec = Section.create(title: params[:section], menu_id: res.menu.id)
			sec_f = sec.id
		else
			sec_f = params[:menu_section].to_i
		end
		foo = FoodItem.create(name: params[:name], price: params[:price], section_id: sec_f, image: params[:image])
		params[:menu_category].each do |sd|
			cati = Category.find(sd.to_i)
			foo.categories << cati
		end
		redirect_to :back , notice: 'Successfully Added!'
	end

	def restaurant_menu
		@restaurant = @owner.restaurants.find(params[:id])
		unless @restaurant.menu.present?
			Menu.create(title: 'Menu' , restaurant_id: @restaurant.id)
			redirect_to :back
		end
	end

	def orders
		@order = Order.where(restaurant_id: @owner.restaurants.pluck(:id))
	end

	def order
		@order = Order.where(restaurant_id: @owner.restaurants.pluck(:id)).find(params[:id])
	end

	def order_accept
		order = Order.where(restaurant_id: @owner.restaurants.pluck(:id)).find(params[:id])
		order.update(status: 1)
		# call job order accepted
		redirect_to owner_order_path(order)
	end

	def order_dispatch
		order = Order.where(restaurant_id: @owner.restaurants.pluck(:id)).find(params[:id])
		order.update(status: 2)
		#job for sending request to riders
		redirect_to owner_order_path(order)
	end

	def food_mark_visible
		food = FoodItem.find(params[:id])
		food.update(publish: !food.publish)
		redirect_to owner_restaurant_menu_path(food.section.menu.restaurant.id) , notice: 'Successfully Done'
	end
end
