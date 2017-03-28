class OwnerController < ApplicationController
	before_action :is_owner , except: [:signin , :approve_signin]
	skip_before_action :verify_authenticity_token, :only => [:approve_signin , :signout]
	layout "dashboard_owner" , except: [:signin]

	def signin
		if session[:owner].present?
			redirect_to '/owner/index' , notice: 'Error: Already SignedIn!'
		end
	end

	def approve_signin
		if owner = User.where(role: 1).where(verified: true).find_by(email: params[:email]).try(:authenticate, params[:password]) 
			if owner.verified == true && owner.block == false
				if owner.inpas.present?
					owner.update(inpas: nil)
				end
				session[:owner] = params[:email]
				redirect_to '/owner/index' , notice: 'Successfully SignedIn!'
			else
				redirect_to :back , notice: 'Error: Dont have access to signin!'
			end
		else
			redirect_to :back , notice: 'Error: Check Email/Password'
		end
	end

	def signout
		session[:owner] = nil
		redirect_to '/owner/signin' , notice: 'Successfully SignedOut!'
	end

	def index

	end

	def restaurants
		if @owner.present?
			@restaurant = @owner.restaurants
		else
			@restaurant = Restaurant.all
		end
	end

	def restaurant_menu_add
		if @owner.present?
			@restaurant = @owner.restaurants.find(params[:id])
		else
			@restaurant = Restaurant.find(params[:id])
		end
		unless @restaurant.menu.present?
			Menu.create(title: 'Menu' , restaurant_id: @restaurant.id)
			redirect_to :back
		end
	end

	def save_fooditem
		if params[:image].present?
			if params[:section].length > 0
				if @owner.present?
					res = @owner.restaurants.find(params[:restaurant_id])
				else
					res = Restaurant.find(params[:restaurant_id])
				end
				
				sec = Section.create(title: params[:section], description: params[:section_desc] , menu_id: res.menu.id)

				sec_f = sec.id
			else
				sec_f = params[:menu_section].to_i
			end
			foo = FoodItem.create(name: params[:name] , description: params[:name_desc] , price: params[:price], section_id: sec_f, image: params[:image])
			if params[:menu_category].present?
				params[:menu_category].each do |sd|
					cati = Category.find(sd.to_i)
					foo.categories << cati
				end
			end
			10.times do |ss|
				if params['option_' + ss.to_s].present?
					if params['option_' + ss.to_s].length > 0
						o = Option.create(title: params['option_' + ss.to_s], price: params['option_p_' + ss.to_s], food_item_id: foo.id)
						3.times do |cotn|
							if params['option_tit_' + ss.to_s + '_' + (cotn+1).to_s].length > 0
								Component.create(title: params['option_tit_' + ss.to_s + '_' + (cotn+1).to_s], price: params['option_' + ss.to_s + '_' + (cotn+1).to_s] , option_id: o.id)
							end
						end
					end
				end

				if params['ingredient_' + ss.to_s].present?
					if params['ingredient_' + ss.to_s].length > 0
						Ingredient.create(title: params['ingredient_' + ss.to_s], price: params['ingredient_p_' + ss.to_s], food_item_id: foo.id)
					end
				end
			end
			redirect_to owner_restaurant_menu_path(params[:restaurant_id]) , notice: 'Successfully Added!'
		else
			redirect_to :back , notice: 'Image Missing'
		end
	end

	def edit_food
		if @owner.present?
			@food = FoodItem.find(params[:id])
			@restaurant = @food.section.menu.restaurant
			unless @restaurant.owner == @owner
				redirect_to '/' , notice: 'Error: Unauthorized'
			end
		else
			@food = FoodItem.find(params[:id])
		end
	end

	def update_food
		if @owner.present?
			@food = FoodItem.find(params[:id])
			restaurant = @food.section.menu.restaurant
			unless restaurant.owner == @owner
				redirect_to '/' , notice: 'Error: Unauthorized'
			end
		else
			@food = FoodItem.find(params[:id])
			restaurant = @food.section.menu.restaurant
		end
		if params[:section].present? && params[:section].length > 1
			s = Section.create(title: params[:section] , menu_id: @food.section.menu.id , description: params[:section_desc])
			@food.update(section_id: s.id)
		elsif params[:menu_section].length > 0 
			@food.update(section_id: params[:menu_section])
		end
		if params[:food_item][:image].present?
			@food.update(image: params[:food_item][:image])
		end
		@food.update(fooditem_update_params)
		redirect_to owner_restaurant_menu_path(restaurant.id) , notice: 'Successfully Updated!'
	end

	def restaurant_menu
		if @owner.present?
			@restaurant = @owner.restaurants.find(params[:id])
		else
			@restaurant = Restaurant.find(params[:id])
		end
		unless @restaurant.menu.present?
			Menu.create(title: 'Menu' , restaurant_id: @restaurant.id)
			redirect_to :back
		end
	end

	def orders
		if @owner.present?
			@order = Order.where(restaurant_id: @owner.restaurants.pluck(:id))
		else
			@order = Order.all
		end
	end

	def order
		if @owner.present?
			@order = Order.where(restaurant_id: @owner.restaurants.pluck(:id)).find(params[:id])
		else
			@order = Order.find(params[:id])
		end
	end

	def order_accept
		if @owner.present?
			order = Order.where(restaurant_id: @owner.restaurants.pluck(:id)).find(params[:id])
		else
			order = Order.find(params[:id])
		end
		order.update(status: 1)
		# call job order accepted
		redirect_to owner_order_path(order)
	end

	def order_dispatch
		if @owner.present?
			order = Order.where(restaurant_id: @owner.restaurants.pluck(:id)).find(params[:id])
		else
			order = Order.find(params[:id])
		end
		order.update(status: 2)
		
		case order.restaurant.order_status
		when 'quiet'
		  delay_interval = Time.now + 5.minutes
		when 'moderate'
		  delay_interval = Time.now + 10.minutes
		else
		  delay_interval = Time.now + 15.minutes
		end

		#job for sending request to riders
		DispatchRiderJob.delay_for(delay_interval).perform_later(order)
		redirect_to owner_order_path(order)
	end

	def food_mark_visible
		food = FoodItem.find(params[:id])
		food.update(publish: !food.publish)
		redirect_to owner_restaurant_menu_path(food.section.menu.restaurant.id) , notice: 'Successfully Done'
	end

	def set_password
		if @owner.try(:authenticate, params[:old_password])
			if (params[:new_password] == params[:confirm_password]) && params[:new_password].length > 6
				@owner.update(password: params[:new_password])
				session[:owner] = nil
				redirect_to '/owner/signin' , notice: 'Successfully Updated Password!'
			else
				redirect_to '/owner/index' , notice: 'Error: Password doesnt match or too short'
			end
		else
			redirect_to '/owner/index' , notice: 'Error: Invalid Password'
		end
	end

	def order_status
		if @owner.present?
			res = @owner.restaurants.find(params[:id])
		else
			res = Restaurant.find(params[:id])
		end
		res.update(order_status: params[:stat])
		render json: {'message' => 'Success'} , status: :ok
	end


	private
	def fooditem_update_params
		params.require(:food_item).permit(:name , :price , :description)
	end
end
