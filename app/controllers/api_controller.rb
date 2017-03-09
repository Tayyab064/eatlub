class ApiController < ApplicationController
	skip_before_action :verify_authenticity_token

	def signup_user
		em = params[:user][:email].downcase
		if User.find_by_email(em)
			render json: {'message' => 'Already signedup'} , status: 409
		else
			c = User.new(signup_user_params)
			c.email = em
			c.role = 'end_user'
			c.save
			render json: {'message' => 'Successfully signedup. Signin now'} , status: 201
		end
	end

	def signin_user
		em = params[:user][:email].downcase
		if u = User.find_by(email: em).try(:authenticate, params[:user][:password] )
			if u.role == 'end_user'
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
			c.save
			render json: {'message' => 'Successfully signedup. Signin now'} , status: 201
		end
	end

	def signin_rider
		em = params[:rider][:email].downcase
		if u = User.find_by(email: em).try(:authenticate, params[:rider][:password] )
			if u.role == 'rider'
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

	private
	def signup_user_params
		params.require(:user).permit(:name, :username , :email , :gender , :password )
	end

	def signin_user_params
		params.require(:user).permit(:email , :password )
	end

	def signup_rider_params
		params.require(:rider).permit(:name, :username , :email , :gender , :password )
	end

	def signin_rider_params
		params.require(:rider).permit(:email , :password )
	end
end
