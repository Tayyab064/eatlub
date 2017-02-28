class WebsiteController < ApplicationController
	skip_before_filter :verify_authenticity_token, :only => [:save_order]
	before_action :is_enduser , only: [:cart , :confirm_order]

	def signin
		if session[:user].present?
			redirect_to :back , notice: "Error: Already SignedIn"
		else
			if usr = User.where(role: 0).find_by(email: params[:email]).try(:authenticate, params[:password]) 
				if usr.block == false
					session[:user] = params[:email]
					redirect_to '/' , notice: "Successfully SignedIn"
				else
					redirect_to :back , notice: "Error: User is blocked"
				end
			else
				redirect_to :back , notice: "Error: Email/Password doesn't match"
			end
		end
	end

	def signup
		if User.find_by_email(params[:email])
			redirect_to :back , notice: 'Error: Already SignedUp!'
		else
			if params[:password] == params[:c_password]
				User.create(name: params[:name] , username: params[:username] , email: params[:email] , password: params[:password] , role: 0)
				redirect_to '/' , notice: 'Successfully SignedUp!'
			else
				redirect_to :back , notice: 'Error: Password doesnot match'
			end
		end
	end

	def index
		@restaurants = Restaurant.approved.order(created_at: 'desc').limit(6)
	end

	def restaurants_nearby
		@restaurants = Restaurant.approved.near(params[:address], 10, :units => :km)
		@address = params[:address]
	end

	def restaurant
		@restaurant = Restaurant.approved.find(params[:id])
		@reviews = @restaurant.reviews
	end

	def submit_restaurant

	end

	def save_restaurant
		p params
		if /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/.match(params[:email]) && params[:name].length > 0
			if User.exists?(email: params[:email])
				use = User.find_by_email(params[:email])
			else		
				use = User.create(name: params[:owner_name] , email: params[:email] , role: 1 , password: '123456')
			end
			if use.role == 'restaurant_owner'
				res = Restaurant.create(name: params[:name] , cuisine: params[:cuisine] , location: params[:location] , typee: params[:typee] , opening_time: Time.parse(params[:opening_time]), closing_time: Time.parse(params[:closing_time]) , owner_id: use.id)
				redirect_to restaurant_page_path(res.id) , notice: "Successfully Submitted"
			else
				redirect_to root_path , notice: "Error: Dont have accesss to submit restaurant"
			end
		else
			redirect_to root_path , notice: "Error: Check parameters"
		end
	end

	def restaurant_menu
		@restaurant = Restaurant.approved.find(params[:id])
	end

	def submit_driver

	end

	def save_driver
		User.create(name: params[:name], username: params[:username] , email: params[:email] , gender: params[:gender] , role: 2 , password: '123456')
		redirect_to :back , notice: "Successfully Submitted"
	end

	def cart

	end

	def confirm_order

	end

	def ajax
		render json: {'message': 'Ready to go'} , status: :ok
	end

	def save_order
		ord = Order.create(address: params[:address] , notes: params[:notes] , restaurant_id: params[:restaurant_id] , user_id: params[:user_id])
		params[:item].each do |cou|
			Item.create(order_id: ord.id , orderable_type: 'FoodItem', orderable_id: params[:item][cou]["id"].to_i , quantity: params[:item][cou]["quantity"].to_i)
		end
		render json: {'message' => 'Saved' } , status: :ok
	end


	private
	def save_restaurant_params
		params.permit(:name , :cuisine , :location , :typee , :opening_time , :closing_time)
	end

end
