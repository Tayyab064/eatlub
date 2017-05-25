class DashboardController < ApplicationController
	before_action :is_admin , except: [:signin , :approve_signin]
	skip_before_action :verify_authenticity_token, :only => [:approve_signin , :signout ]
	layout "dashboard_admin" , except: [:signin]

	def signin
		if session[:admin].present?
			redirect_to '/dashboard/index' , notice: 'Error: Already SiginedIn!'
		end
	end

	def approve_signin
		p params
		if admin = User.where(role: 3).find_by(email: params[:email]).try(:authenticate, params[:password]) 
			if admin.verified == true && admin.block == false
				if admin.inpas.present?
					admin.update(inpas: nil)
				end
				session[:admin] = params[:email]
				redirect_to '/dashboard/index' , notice: 'Successfully SignedIn!'
			else
				redirect_to :back , notice: 'Error: Dont have access to signin'
			end
		else
			redirect_to :back , notice: 'Error: Check Email/Password'
		end
	end

	def signout
		session[:admin] = nil
		redirect_to '/dashboard/signin' , notice: 'Successfully SignedOut!'
	end

	def index
		@order = Order.all
		@rider = User.where(role: 'rider')
		@user = User.where(role: 'end_user')
		@categories = DeliverCategory.all
		@deliver = Deliverable.approved
	end

	def restaurants
		c = DeliverCategory.find_by_name('restaurant')
		@restaurant = c.deliverables
		respond_to do |format|
			format.html
			format.csv { send_data @restaurant.to_csv }
		end
	end

	def end_user
		@user = User.where(role: 0)
		respond_to do |format|
			format.html
			format.csv { send_data @user.to_csv }
		end
	end

	def set_password_user
		user = User.find(params[:format])
		if params[:password].length > 8 && params[:password].length < 16
			user.update(password: params[:password] , inpas: params[:password] , verified: true)
			UserMailer.set_password(user).deliver_now
			redirect_to :back , notice: 'Successfully Verified'
		else
			redirect_to :back , notice: 'Error: Check password length'
		end
	end

	def unblock_user
		user = User.find(params[:format])
		user.update(block: false)
		redirect_to dashboard_end_users_path , notice: 'Successfully Unblocked'
	end

	def block_user
		user = User.find(params[:format])
		user.update(block: true)
		redirect_to dashboard_end_users_path , notice: 'Successfully Blocked'
	end

	def restaurant_owner
		@user = User.where(role: 1)
		respond_to do |format|
			format.html
			format.csv { send_data @user.to_csv }
		end
	end

	def rider
		@user = User.where(role: 2)
		respond_to do |format|
			format.html
			format.csv { send_data @user.to_csv }
		end
	end

	def admin
		@user = User.where(role: 3)
	end

	def rest_mark_approved
		restaurant = Restaurant.find(params[:id])
		restaurant.update(status: 1)
		UserMailer.restapprove(restaurant).deliver_now
		unless restaurant.owner.password.present?
			#ow = restaurant.owner
			#ow.update(password: SecureRandom.urlsafe_base64(6))
			#UserMailer.set_password(ow).deliver_later
		end
		redirect_to dashboard_restaurants_path , notice: 'Successfully Approved'
	end

	def rest_mark_popular
		restaurant = Restaurant.find(params[:id])
		restaurant.update(popular: !restaurant.popular)
		redirect_to dashboard_restaurants_path , notice: 'Successfully Done'
	end

	def set_commission
		restaurant = Restaurant.find(params[:id])
		restaurant.update(commission: params[:commission])
		redirect_to dashboard_restaurants_path , notice: 'Successfully Done'
	end

	def block_restaurant
		restaurant = Restaurant.find(params[:id])
		restaurant.update(status: 2)
		redirect_to dashboard_restaurants_path , notice: 'Successfully Blocked'
	end

	def unblock_restaurant
		restaurant = Restaurant.find(params[:id])
		restaurant.update(status: 1)
		redirect_to dashboard_restaurants_path , notice: 'Successfully Unblocked'
	end

	def rider_orders
		@orders = Order.where(rider_id: params[:id])
		@total = 0.0
		@today = 0.0
		@month = 0.0
		order = @orders.where(status: 'completed')
		order.each do |se|
			@total = @total + se.restaurant.delivery_fee
		end
		order.where("created_at >= ?", Time.zone.now.beginning_of_day).each do |se|
			@today = @today + se.restaurant.delivery_fee
		end
		order.where("created_at >= ?", Time.now.beginning_of_month).each do |se|
			@month = @month + se.restaurant.delivery_fee
		end
	end

	def user_orders
		@orders = User.find(params[:id]).orders
	end

	def wallet
		@wallet = Wallet.all
	end

	def give_credit
		c = params[:user].split('EU')[1]
		if user = User.find_by_id(c)
			amo = user.wallet.amount + params[:amount].to_i
			user.wallet.update(amount: amo)
			redirect_to user_wallets_path , notice: 'Successfully wallet updated'
		else
			redirect_to user_wallets_path , notice: 'Error: Invalid User ID'
		end
	end

	def promocode
		@promocode = Promocode.all
	end

	def save_promocode
		Promocode.create(promocode: params[:code] , amount: params[:amount])
		redirect_to dashboard_promocode_path , notice: 'Successfully added'
	end

	def deliverable_cat
		@cat = DeliverCategory.all
	end

	def save_deliverable
		DeliverCategory.create(image: params[:image] , name: params[:category] , description: params[:description])
		redirect_to :back
	end

	def deliverable
		c = DeliverCategory.find_by_name('restaurant')
		@deliverable = Deliverable.where.not(deliver_category_id: c.id)
	end

	def approve_deliverables
		deliverable = Deliverable.find(params[:id])
		deliverable.update(status: 1)
		UserMailer.restapprove(deliverable).deliver_now
		redirect_to :back , notice: 'Successfully Approved'
	end

	def deliverable_mark_popular
		deliverable = Deliverable.find(params[:id])
		deliverable.update(popular: !deliverable.popular)
		redirect_to :back , notice: 'Successfully Done'
	end

	def set_commission_deliverable
		deliverable = Deliverable.find(params[:id])
		deliverable.update(commission: params[:commission])
		redirect_to :back , notice: 'Successfully Done'
	end

	def block_deliverable
		deliverable = Deliverable.find(params[:id])
		deliverable.update(status: 2)
		redirect_to :back , notice: 'Successfully Blocked'
	end

	def unblock_deliverable
		deliverable = Deliverable.find(params[:id])
		deliverable.update(status: 1)
		redirect_to :back , notice: 'Successfully Unblocked'
	end

	def destroy_del_cat
		if c = DeliverCategory.find_by_id(params[:id])
			c.destroy
		end
		redirect_to dashboard_deliverable_cat_path , notice: 'Successfully Deleted'
	end

	def prices_delivery
		@price = Price.all
	end

	def price_save
		Price.create(start_km: params[:start] , end_km: params[:end] , price: params[:price])
		redirect_to :prices_delivery , notice: 'Successfully Added'
	end

	def add_deliverable

	end

	def add_deliverable_save
		use = User.find_by_email(session[:admin])
		res = Deliverable.create( deliver_category_id: params[:category_test] , name: params[:name]  , opening_time: Time.parse(params[:opening_time]), closing_time: Time.parse(params[:closing_time]) , owner_id: use.id , weekly_order: params[:weekly_order] , no_of_location: params[:no_of_location] , delivery: params[:delivery] , delivery_fee: 2.5 , image: params[:image] , cover: params[:cover] , phone_number: params[:phone_number] , partner: false , status: 1 )
		p res.errors
		Branch.create( address: params[:location] , post_code: params[:post_code] , deliverable_id: res.id)
		redirect_to add_deliverable_path , notice: 'Successfully Added'
	end

	def rest_mark_partner
		restaurant = Restaurant.find(params[:id])
		restaurant.update(partner: !restaurant.popular)
		redirect_to dashboard_restaurants_path , notice: 'Successfully Done'
	end
end
