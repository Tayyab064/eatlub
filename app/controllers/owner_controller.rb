class OwnerController < ApplicationController

	def index

	end

	def restaurants
		@restaurant = Restaurant.all
	end
end
