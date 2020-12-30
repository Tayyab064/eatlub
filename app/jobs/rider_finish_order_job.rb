class RiderFinishOrderJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later

    tot_pri = 0.0
    args.first.items do |item|
    	final_pri = 0.0
		item.ingredients do |ingre|
			if Ingredient.exists?(ingre)
				ing = Ingredient.find(ingre)
				final_pri = final_pri + ing.price.to_f
			end
		end
		item.option do |opti|
			if Option.exists?(opti)
				ing = Option.find(opti)
				final_pri = final_pri + ing.price.to_f
			end
		end

		final_pri = final_pri + item.orderable.price
		final_pri = final_pri * item.quantity

		tot_pri = tot_pri + final_pri
	end

    require 'fcm'
	fcm_driver = FCM.new("AAAAnaUPlck:APA91bGk3JE9VrDJcsgd5hZtRNLsJ7Na6ZHaKCe-HzaCp-7I1CelElMCLr1wLzHkn-4Z-3r7Pyypbfa373lWkz3PtM58zqKzmj8rhGg0DH3Oq_jIwF1MoKT2OGU4O7pz_xVE8vxBViF4")

	options = {data: {message: 'Order Finish' , title: 'EatLub' , redirect: 'Order Finish' , order_id: args.first.id , price: tot_pri.round(2) }}
	response = fcm_driver.send(args.first.user.devices.where(device: 'Android').pluck(:token), options)
  end
end
