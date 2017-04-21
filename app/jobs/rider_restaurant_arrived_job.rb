class RiderRestaurantArrivedJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    require 'gcm'
	gcm_driver = GCM.new("AIzaSyBTGPNS1zaUHZmpqlPw56XMvNti2rdksC8")

	options = {data: {message: 'Rider is at restaurant to pick order' , title: 'Deliverush' , redirect: 'Pick Order' , order_id: args.first.id }}
	response = gcm_driver.send(args.first.user.devices.where(device: 'Android').pluck(:token), options)
  end
end
