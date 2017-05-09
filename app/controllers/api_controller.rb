class ApiController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :restrict_user , only: [:create_order , :get_orders , :get_specific_order , :tip]
	before_action :restrict_rider , only: [:rider_accept , :arrived_rest_order , :arrived_user_order , :finish_order , :rider_earn , :pay_bill , :online ]

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
				UserMailer.usersignup(c).deliver_now
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
				UserMailer.usersignup(c).deliver_now
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
			@restaurants = Restaurant.approved.near( @latlong, 20)
			@popular = Restaurant.approved.where(popular: true).limit(5)
		else
			@message = 'Lat/Long missing'
			render status: 403
		end
	end

	def restaurant_menu
		if @restaurant = Restaurant.approved.find_by_id(params[:id])
			render status: 200
		else
			@message = 'Cant find restaurant with id ' + params[:id]
			render status: 404
		end
	end

	def nearby_deliverable
		if params[:latitude].present? && params[:longitude].present? && params[:deliverable].present?
			@latlong = [params[:latitude], params[:longitude]]
			if c = DeliverCategory.find_by_name(params[:deliverable])
				bra = Branch.near( @latlong, 20).map(&:deliverable_id)
				@restaurants = Deliverable.approved.where(id: bra).where(deliver_category_id: c.id)
				#@restaurants = c.deliverables.approved.near( @latlong, 20)
			else
				@message = 'Invalid deliverable name'
				render status: 403
			end
		else
			@message = 'Lat/Long missing'
			render status: 403
		end
		@popular = c.deliverables.approved.where(popular: true).limit(5)
	end

	def deliverable_menu
		if @restaurant = Deliverable.approved.find_by_id(params[:id])
			render status: 200
		else
			@message = 'Cant find deliverable with id ' + params[:id]
			render status: 404
		end
	end

	def create_order
		if params[:order].length > 0
			if params[:order][:orderable_type] == "Restaurant"
				res = Restaurant.approved.find_by_id(params[:order][:orderable_id])
			else
				res = Deliverable.approved.find_by_id(params[:order][:orderable_id])
				unless res.deliver_category.name == params[:order][:orderable_type]
					res = nil
				end
			end
			if res.present?
				@ord = Order.create(address: params[:order][:address], notes:  params[:order][:notes], ordera_id: params[:order][:orderable_id] , ordera_type: params[:order][:orderable_type] , user_id: @current_user.id)
				params[:order][:item].each do |itm|
					it = Item.create(order_id: @ord.id , orderable_id: params[:order][:item][itm][:id].to_i, orderable_type: 'FoodItem', quantity: params[:order][:item][itm][:quantity].to_i)
					if params[:order][:item][itm][:ingredients].present?
						params[:order][:item][itm][:ingredients].split(',').each do |infg|
							it.ingredients.push(infg.to_i)
						end
					end

					if params[:order][:item][itm][:option].present?
						params[:order][:item][itm][:option].split(',').each do |infg|
							it.option.push(infg.to_i)
						end
					end
					it.save
				end
				PlaceOrderJob.perform_later(@ord)
				UserMailer.ordercheckout(@ord).deliver_now
				render status: 201
    		else
    			@message = 'Invalid orderable id'
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

	def get_specific_order
		@order = @current_user.orders.find(params[:id])
		render status: 200
	end

	def pay_bill
		if ord = Order.where(rider_id: @current_rider.id).find_by_id(params[:id])
			if ord.status == 'finish'
				ord.update(status: 'completed')
				UserMailer.orderdelivery(ord).deliver_now
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
			if @ord.status == 'approved' && @ord.rider_id.nil?
				@ord.update(rider_id: @current_rider.id , assigned_at: Time.now)
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
			if ord.status == 'approved'
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

	def forget_password
		if u = User.find_by_email(params[:email])
			u.regenerate_password_reset_token
			UserMailer.forget_password(u).deliver_now
			render json: {'message' => 'Kindly check your email'} , status: :ok
		else
			render json: {'message' => 'Invalid email address'} , status: 404
		end
	end

	def tip
		order = @current_user.orders.find(params[:id])
		if order.status == 'finish'
			order.update(tip: params[:tip])
		end
		render json: {'message' => "Tip is #{order.tip}"} , status: 200
	end

	def test_noti
		order = Order.last
		DispatchRiderJob.perform_later(order)
		render json: {'message' => 'Sending Notifications'} , status: 200
	end

	def get_categories
		@cat = DeliverCategory.all
		render status: 200
	end

	def popular_categories
		li = []
		res_id = Restaurant.approved.where(popular: true).pluck(:id).sample
		DeliverCategory.all.each do |cat|
			dk = cat.deliverables.approved.where(popular: true).pluck(:id).sample
			if dk.present?
				li.push(dk)
			end
		end
		if res_id.present?
			@restaurant = Restaurant.approved.where(id: res_id)
		end
		@deliverable = Deliverable.approved.find(li)
	end

	def rider_earn
		case params[:month]
		when 'month'
			@order_mon = Order.where(rider_id: @current_rider.id).for_year.order(created_at: 'ASC').group_by(&:month)
		when 'week'
			@order_wee = Order.where(rider_id: @current_rider.id).for_year.order(created_at: 'ASC').group_by(&:week)
		else
			yea = Date.today.year
			mont = Date.today.month
			tim = Time.local(yea,mont,1,12,00,0) 
			last_dat = Time.days_in_month(tim.month, yea)
			rid = Order.where(rider_id: @current_rider.id).where("created_at >= ? and created_at <= ?", "#{yea}-#{mont}-01", "#{yea}-#{mont}-#{last_dat}")
			@order_dai = rid.for_year.order(created_at: 'ASC').group_by(&:daily)
		end
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
