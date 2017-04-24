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

    require 'gcm'
	gcm_driver = GCM.new("AIzaSyBTGPNS1zaUHZmpqlPw56XMvNti2rdksC8")

	options = {data: {message: 'Order Finish' , title: 'Deliverush' , redirect: 'Order Finish' , order_id: args.first.id , price: tot_pri.round(2) }}
	response = gcm_driver.send(args.first.user.devices.where(device: 'Android').pluck(:token), options)
  end
end
