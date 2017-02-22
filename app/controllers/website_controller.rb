class WebsiteController < ApplicationController

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
				redirect_to restaurant_page_path(res.id)
			else
				redirect_to root_path
			end
		else
			redirect_to root_path
		end
	end

	def restaurant_menu
		@restaurant = Restaurant.approved.find(params[:id])
	end

	def submit_driver

	end

	def save_driver
		User.create(name: params[:name], username: params[:username] , email: params[:email] , gender: params[:gender] , role: 2 , password: '123456')
		redirect_to :back
	end


	private
	def save_restaurant_params
		params.permit(:name , :cuisine , :location , :typee , :opening_time , :closing_time)
	end
end
