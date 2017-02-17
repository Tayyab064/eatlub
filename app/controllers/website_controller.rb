class WebsiteController < ApplicationController

	def index
		@restaurants = Restaurant.order(created_at: 'desc').limit(6)
	end

	def restaurants_nearby
		@restaurants = Restaurant.order(created_at: 'desc').limit(20)
		@address = params[:address]
	end

	def restaurant
		@restaurant = Restaurant.find(params[:id])
	end

	def submit_restaurant

	end

	def save_restaurant
		p params
		if params[:name].length > 0
			res = Restaurant.create(name: params[:name] , cuisine: params[:cuisine] , location: params[:location] , typee: params[:typee] , opening_time: Time.parse(params[:opening_time]), closing_time: Time.parse(params[:closing_time]) , owner_id: User.where(role: 1).last.id)
			redirect_to restaurant_page_path(res.id)
		else
			redirect_to root_path
		end
	end


	private
	def save_restaurant_params
		params.permit(:name , :cuisine , :location , :typee , :opening_time , :closing_time)
	end
end
