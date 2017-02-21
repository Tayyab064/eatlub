class ErrorsController < ApplicationController
	layout false
	def show
	   @status_code = params[:code] || 500
	end
end
