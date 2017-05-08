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
				UserMailer.usersignup(c).deliver_now
				session[:user] = params[:email]
				redirect_to '/' , notice: 'Successfully SignedUp!'
			else
				redirect_to :back , notice: 'Error: Password doesnot match'
			end
		end
	end

	def signout
		if session[:user].present?
			session[:user] = nil
			redirect_to '/' , notice: "Successfully Signedout"
		else
			redirect_to :back , notice: 'Error: Signin first'
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

	def search_postal
		if params[:address].present?
			@address = params[:address]
		else
			@address = 'N19 4EE'
		end
		@ca = DeliverCategory.all
	end

	def restaurants_nearby
		#@restaurants = Restaurant.approved.near(params[:address], 10, :units => :km)
		@lat = params[:lat]
		@long = params[:long]
		if params[:address].present?
			@restaurants = Restaurant.approved.where(post_code: params[:address])
			@address = params[:address]
		else
			@restaurants = Restaurant.approved.limit(0)
			@address = params[:address]
		end

		@res_count = 0
		@restaurants.each do |s|
			@res_count += 1
		end
		@name_te = 'Restaurant'
	end

	def restaurant
		@images = []
		@restaurant = Restaurant.approved.find(params[:id])
		@reviews = @restaurant.reviews
		if @restaurant.menu.present?
			image = FoodItem.where(section_id: @restaurant.menu.sections.pluck(:id))
			image.each do |im|
				if im.image_url.present?
					@images.push(im)
				end
			end
		end
		p @images
	end

	def submit_restaurant

	end

	def save_restaurant
		p params
		if params[:category_test].present?
			unless /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/.match(params[:emaili]) && params[:namei].length > 0 && params[:imagei].present? && params[:coveri].present? 
				redirect_to :back , notice: "Error: Check parameters"
			end	
			if User.exists?(email: params[:emaili])
				use = User.find_by_email(params[:emaili])
			else		
				use = User.create(name: params[:owner_namei] , email: params[:emaili] , role: 1 , password: '123456' , mobile_number: params[:mobile_numberi] )
			end
			if use.role == 'restaurant_owner'
				res = Deliverable.create( deliver_category_id: params[:category_test] , name: params[:namei] , location: params[:locationi]  , opening_time: Time.parse(params[:opening_timei]), closing_time: Time.parse(params[:closing_timei]) , owner_id: use.id , weekly_order: params[:weekly_orderi] , no_of_location: params[:no_of_location] , delivery: params[:delivery] , delivery_fee: 2.5 , image: params[:imagei] , cover: params[:coveri] , phone_number: params[:phone_numberi] , post_code: params[:post_codei])
				UserMailer.restaurant_registered(use).deliver_now
				redirect_to thankyou_path , notice: "Successfully Submitted"
			else
				redirect_to root_path , notice: "Error: Dont have accesss to submit restaurant"
			end
		else
			unless /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/.match(params[:email]) && params[:name].length > 0 && params[:image].present? && params[:cover].present? 
				redirect_to :back , notice: "Error: Check parameters"
			end	
			if User.exists?(email: params[:email])
				use = User.find_by_email(params[:email])
			else		
				use = User.create(name: params[:owner_name] , email: params[:email] , role: 1 , password: '123456' , mobile_number: params[:mobile_number] )
			end
			if use.role == 'restaurant_owner'
				res = Restaurant.create(name: params[:name] , cuisine: params[:cuisine] , location: params[:location] , typee: params[:typee] , opening_time: Time.parse(params[:opening_time]), closing_time: Time.parse(params[:closing_time]) , owner_id: use.id , weekly_order: params[:weekly_order] , no_of_location: params[:no_of_location] , delivery: params[:delivery] , delivery_fee: 2.5 , image: params[:image] , cover: params[:cover] , phone_number: params[:phone_number] , post_code: params[:post_code])
				if params[:max_order].to_i > 0
					Deal.create(total_order: params[:max_order] , discount: params[:discount] , restaurant_id: res.id)
				end
				UserMailer.restaurant_registered(use).deliver_now
				redirect_to thankyou_path , notice: "Successfully Submitted"
			else
				redirect_to root_path , notice: "Error: Dont have accesss to submit restaurant"
			end
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
		UserMailer.usersignup(c).deliver_now
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
		
		if params[:deliverable] == true
			ordes_typ = 'Deliverable'
		else
			ordes_typ = 'Restaurant'
		end
		ord = Order.create(address: ad , notes: params[:notes] , ordera_id: params[:restaurant_id] , ordera_type: ordes_typ , user_id: params[:user_id])
		p ord.errors
		params[:item].each do |cou|		
			Item.create(order_id: ord.id , orderable_type: 'FoodItem', orderable_id: params[:item][cou]["id"].to_i , quantity: params[:item][cou]["quantity"].to_i , option: params[:item][cou]["option"].tr('[]', '').split(',').map(&:to_i) , ingredients: params[:item][cou]["ingredients"].tr('[]', '').split(',').map(&:to_i) )
		end
		UserMailer.ordercheckout(ord).deliver_now
		render json: {'message' => 'Saved' , 'id' => ord.id } , status: :ok
	end

	def orders
		@orders = @end_user.orders.order(created_at: 'DESC')
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
		if params[:typee].present?
			re_typ = params[:typee]
		else
			re_typ = 'Restaurant'
		end
		Review.create(summary: params[:review_text], quality: params[:food_review], price: params[:price_review], punctuality: params[:punctuality_review], courtesy: params[:courtesy_review], reviewable_id: params[:restaurant] , reviewable_type: re_typ , reviewer_id: @end_user.id)
		redirect_to :back , notice: 'Successfully reviewed!'
	end

	def nearby_deliverables
		@lat = params[:lat]
		@long = params[:long]
		de = DeliverCategory.find_by_name(params[:name])
		if de.present?
			@restaurants = Deliverable.approved.where(deliver_category_id: de.id).where(post_code: params[:address])
			@address = params[:address]
		else
			@restaurants = Deliverable.approved.limit(0)
			@address = params[:address]
		end

		@res_count = 0
		@restaurants.each do |s|
			@res_count += 1
		end
		@name_te = params[:name]
	end

	def get_deliverable
		@images = []
		@restaurant = Deliverable.approved.find(params[:id])
		@reviews = @restaurant.reviews
		if @restaurant.menu.present?
			image = FoodItem.where(section_id: @restaurant.menu.sections.pluck(:id))
			image.each do |im|
				if im.image_url.present?
					@images.push(im)
				end
			end
		end
		p @images
	end

	def get_deliverable_item
		@restaurant = Deliverable.approved.find(params[:id])
	end

	def sub_news
		if User.exists?(email: params[:email])
			use = User.find_by_email(params[:email])
			noti =  'Error: User already subscribed'
		else
			use = User.create(email: params[:email] , role: 1 , password: '123456')
			noti = 'Successfully subscribed'
			UserMailer.userreg(use).deliver_now
		end
		redirect_to '/' , notice: noti
	end


	private
	def save_restaurant_params
		params.permit(:name , :cuisine , :location , :typee , :opening_time , :closing_time)
	end

end
