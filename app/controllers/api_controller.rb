class ApiController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :restrict_user , only: [:create_order , :get_orders]
	before_action :restrict_rider , only: [:rider_accept , :arrived_rest_order , :arrived_user_order , :finish_order , :pay_bill , :online]

	def signup_user
		em = params[:user][:email].downcase
		if User.find_by_email(em)
			render json: {'message' => 'Already signedup'} , status: 409
		else
			c = User.new(signup_user_params)
			c.email = em
			c.role = 'end_user'
			if c.save
				Wallet.create(user_id: User.find_by_email(em).id)
				render json: {'message' => 'Successfully signedup. Signin now'} , status: 201
			else
				render json: {'message' => 'Something went wrong. Check params'} , status: 422
			end
		end
	end

	def signin_user
		em = params[:user][:email].downcase
		if u = User.find_by(email: em).try(:authenticate, params[:user][:password] )
			if u.role == 'end_user'
				unless u.devices.find_by_token params[:user][:token]
					if u.devices.count >= 5
	    				u.devices.first.update(token: params[:user][:token], device: params[:user][:device])
					else
						Device.create(token: params[:user][:token], device: params[:user][:device] , user_id: u.id)
					end
				end
				u.regenerate_token
				@user = u
				render status: 200
			else
				@message = 'Dont have access to login to user account'
				render status: 401
			end
		else
			@message = 'Invalid email/password'
			render status: 401
		end
	end

	def signup_rider
		em = params[:rider][:email].downcase
		if User.find_by_email(em)
			render json: {'message' => 'Already signedup'} , status: 409
		else
			c = User.new(signup_rider_params)
			c.email = em
			c.role = 'rider'
			if c.save
				render json: {'message' => 'Successfully signedup. Signin now'} , status: 201
			else
				render json: {'message' => 'Something went wrong. Check params'} , status: 422
			end
		end
	end

	def signin_rider
		em = params[:rider][:email].downcase
		if u = User.find_by(email: em).try(:authenticate, params[:rider][:password] )
			if u.role == 'rider'
				unless u.devices.find_by_token params[:rider][:token]
					if u.devices.count >= 5
	    				u.devices.first.update(token: params[:rider][:token], device: params[:rider][:device])
					else
						Device.create(token: params[:rider][:token], device: params[:rider][:device] , user_id: u.id)
					end
				end
				u.regenerate_token
				@rider = u
				render status: 200
			else
				@message = 'Dont have access to login to user account'
				render status: 401
			end
		else
			@message = 'Invalid email/password'
			render status: 401
		end
	end

	def nearby_restaurants
		if params[:latitude].present? && params[:longitude].present?
			@latlong = [params[:latitude], params[:longitude]]
			@restaurants = Restaurant.near( @latlong, 20)
		else
			@message = 'Lat/Long missing'
			render status: 403
		end
	end

	def restaurant_menu
		if @restaurant = Restaurant.find_by_id(params[:id])
			render status: 200
		else
			@message = 'Cant find restaurant with id ' + params[:id]
			render status: 404
		end
	end

	def create_order
		if params[:order].length > 0
			if res = Restaurant.find_by_id(params[:order][:restaurant_id])
				@ord = Order.create(address: params[:order][:address], notes:  params[:order][:notes], restaurant_id: res.id , user_id: @current_user.id)
				params[:order][:item].each do |itm|
					Item.create(order_id: @ord.id , orderable_id: params[:order][:item][itm][:id].to_i, orderable_type: 'FoodItem', quantity: params[:order][:item][itm][:quantity].to_i)
				end
				PlaceOrderJob.perform_later(@ord)
				render status: 201
    		else
    			@message = 'Invalid restaurant id'
    			render status: 404
    		end
		else
			@message = 'Order must contain some fooditems'
			render status: 422
		end
	end

	def get_orders
		@order = @current_user.orders.order(updated_at: 'DESC')
		render status: 200
	end

	def pay_bill
		if ord = Order.where(rider_id: @current_rider.id).find_by_id(params[:id])
			if ord.status == 'finish'
				ord.update(status: 'completed')
				render json: {'message' => 'Order completed'} , status: 200
			else
				render json: {'message' => 'Order expired'} , status: 409
			end
		else
			render json: {'message' => 'Invalid Order id'} , status: 404
		end
	end

	def rider_accept
		if @ord = Order.find_by_id(params[:id])
			if @ord.status == 'dispatched' && @ord.rider_id.nil?
				@ord.update(rider_id: @current_rider.id)
				RiderAcceptOrderJob.perform_later(@ord)
				render status: 200
			else
				@message = 'Order Expired'
				render status: 409
			end
		else
			@message = 'Invalid order id'
			render status: 404
		end
	end

	def finish_order
		if ord = Order.where(rider_id: @current_rider.id).find_by_id(params[:id])
			if ord.status == 'arrived_user'
				ord.update(status: 'finish')
				RiderFinishOrderJob.perform_later(ord)
				render json: {'message' => 'Order finished'} , status: 200
			else
				render json: {'message' => 'Order expired'} , status: 409
			end
		else
			render json: {'message' => 'Invalid Order id'} , status: 404
		end
	end

	def arrived_rest_order
		if ord = Order.where(rider_id: @current_rider.id).find_by_id(params[:id])
			if ord.status == 'dispatched'
				ord.update(status: 'arrived_restaurant' , assigned: Time.now)
				RiderRestaurantArrivedJob.perform_later(ord)
				render json: {'message' => 'Collect order'} , status: 200
			else
				render json: {'message' => 'Order expired'} , status: 409
			end
		else
			render json: {'message' => 'Invalid Order id'} , status: 404
		end
	end

	def arrived_user_order
		if ord = Order.where(rider_id: @current_rider.id).find_by_id(params[:id])
			if ord.status == 'arrived_restaurant'
				ord.update(status: 'arrived_user')
				RiderUserArrivedJob.perform_later(ord)
				render json: {'message' => 'Call user'} , status: 200
			else
				render json: {'message' => 'Order expired'} , status: 409
			end
		else
			render json: {'message' => 'Invalid Order id'} , status: 404
		end
	end

	def online
		unless @current_rider.detail.present?
			Detail.create(online: true, rider_id: @current_rider.id )
		end
		@current_rider.detail.update(online: !@current_rider.detail.online)
		render json: {'status' => @current_rider.detail.online ? 'Online' : 'Offline'} , status: :ok
	end

	private
	def signup_user_params
		params.require(:user).permit(:name, :username , :email , :gender , :password , :mobile_number)
	end

	def signin_user_params
		params.require(:user).permit(:email , :password )
	end

	def signup_rider_params
		params.require(:rider).permit(:name, :username , :email , :gender , :password , :mobile_number)
	end

	def signin_rider_params
		params.require(:rider).permit(:email , :password )
	end
end
