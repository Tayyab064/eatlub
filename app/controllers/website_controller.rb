class WebsiteController < ApplicationController
	skip_before_filter :verify_authenticity_token, :only => [:save_order]
	before_action :is_enduser , only: [:cart , :confirm_order , :orders , :order , :cancel_order , :leaveareview]
	before_action :is_enduser_check

	def signin
		if session[:user].present?
			redirect_to :back , notice: "Error: Already SignedIn"
		else
			if usr = User.where(role: 0).find_by(email: params[:email]).try(:authenticate, params[:password])
				if usr.block == false
					if usr.inpas.present?
						usr.update(inpas: nil)
					end
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
				c = User.create(name: params[:name] , username: params[:username] , email: params[:email] , password: params[:password] , role: 0)
				Wallet.create(user_id: c.id)
				redirect_to '/' , notice: 'Successfully SignedUp!'
			else
				redirect_to :back , notice: 'Error: Password doesnot match'
			end
		end
	end

	def forget_password
		if u = User.find_by_email(params[:email])
			u.regenerate_password_reset_token
			UserMailer.forget_password(u).deliver_now
			redirect_to '/' , notice: 'Kindly check your email'
		else
			redirect_to '/' , notice: 'Error: Invalid email!'
		end
	end

	def set_password
		unless @user = User.find_by_password_reset_token(params[:token])
			redirect_to '/' , notice: 'Error: Invalid password reset token'
		end
	end

	def save_password
		unless user = User.find_by_password_reset_token(params[:token])
			redirect_to '/' , notice: 'Error: Invalid password reset token'
		end
		user.update(password: params[:password] , password_reset_token: nil)
		redirect_to '/' , notice: 'Password reset. Kindly signin!'
	end

	def index
		@restaurants = Restaurant.approved.order(created_at: 'DESC').limit(6)
		#@res_count = Restaurant.approved.count
		#@ord_count = Order.where(status: 'completed').count
		#@end_user_count = User.where(role: 'end_user').count
	end

	def restaurant_listing
		@restaurants = Restaurant.approved.order(created_at: 'desc').limit(100)
	end

	def restaurant_grid
		@restaurants = Restaurant.approved.order(created_at: 'desc').limit(100)
	end

	def restaurants_nearby
		#@restaurants = Restaurant.approved.near(params[:address], 10, :units => :km)
		@restaurants = Restaurant.approved.where(post_code: params[:address])
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
		if /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/.match(params[:email]) && params[:name].length > 0 && params[:image].present? && params[:cover].present? 
			if User.exists?(email: params[:email])
				use = User.find_by_email(params[:email])
			else		
				use = User.create(name: params[:owner_name] , email: params[:email] , role: 1 , password: '123456' , mobile_number: params[:mobile_number] )
			end
			if use.role == 'restaurant_owner'
				res = Restaurant.create(name: params[:name] , cuisine: params[:cuisine] , location: params[:location] , typee: params[:typee] , opening_time: Time.parse(params[:opening_time]), closing_time: Time.parse(params[:closing_time]) , owner_id: use.id , weekly_order: params[:weekly_order] , no_of_location: params[:no_of_location] , delivery: params[:delivery] , image: params[:image] , cover: params[:cover] , phone_number: params[:phone_number])
				if params[:max_order].to_i > 0
					Deal.create(total_order: params[:max_order] , discount: params[:discount] , restaurant_id: res.id)
				end
				UserMailer.restaurant_registered(use).deliver_now
				redirect_to thankyou_path , notice: "Successfully Submitted"
			else
				redirect_to root_path , notice: "Error: Dont have accesss to submit restaurant"
			end
		else
			redirect_to :back , notice: "Error: Check parameters"
		end
	end

	def restaurant_menu
		@restaurant = Restaurant.approved.find(params[:id])
	end

	def submit_driver

	end

	def save_driver
		c = User.create(name: params[:name], username: params[:username] , email: params[:email] , gender: params[:gender] , role: 2 , password: '123456')
		Detail.create(city: params[:mycity] , vehicle: params[:myvehi] , rider_id: c.id)
		redirect_to thankyou_path , notice: "Successfully Submitted"
	end

	def cart

	end

	def confirm_order

	end

	def ajax
		render json: {'message': 'Ready to go'} , status: :ok
	end

	def save_order
		if params[:address].length > 1
			ad = params[:address]
		else
			ad = Address.find(params[:address_id]).address
		end
		
		ord = Order.create(address: ad , notes: params[:notes] , restaurant_id: params[:restaurant_id] , user_id: params[:user_id])
		params[:item].each do |cou|		
			Item.create(order_id: ord.id , orderable_type: 'FoodItem', orderable_id: params[:item][cou]["id"].to_i , quantity: params[:item][cou]["quantity"].to_i , option: params[:item][cou]["option"].tr('[]', '').split(',').map(&:to_i) , ingredients: params[:item][cou]["ingredients"].tr('[]', '').split(',').map(&:to_i) )
		end
		render json: {'message' => 'Saved' , 'id' => ord.id } , status: :ok
	end

	def orders
		@orders = @end_user.orders
	end

	def order
		unless @order = @end_user.orders.find_by_id(params[:id])
			redirect_to '/' , notice: "Error: Invalid order id"
		end
		if @order.rider_id.present?
			@rider = User.find_by_id(@order.rider_id)
		end
	end

	def cancel_order
		unless order = @end_user.orders.find_by_id(params[:id])
			redirect_to web_user_orders_path , notice: "Error: Invalid order id"
		end
		if order.status == 'pending'
			order.update(status: 'cancel')
			redirect_to web_user_order_path(params[:id]) , notice: 'Order canceled'
		else
			redirect_to web_user_order_path(params[:id]) , notice: 'Error: Order cannot be canceled at this time'
		end
	end

	def thankyou

	end

	def leaveareview
		Review.create(summary: params[:review_text], quality: params[:food_review], price: params[:price_review], punctuality: params[:punctuality_review], courtesy: params[:courtesy_review], restaurant_id: params[:restaurant], reviewer_id: @end_user.id)
		redirect_to restaurant_page_path(params[:restaurant]) , notice: 'Successfully reviewed!'
	end


	private
	def save_restaurant_params
		params.permit(:name , :cuisine , :location , :typee , :opening_time , :closing_time)
	end

end
