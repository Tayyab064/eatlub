class PlaceOrderJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    require 'fcm'
	fcm_driver = FCM.new("AAAAnaUPlck:APA91bGk3JE9VrDJcsgd5hZtRNLsJ7Na6ZHaKCe-HzaCp-7I1CelElMCLr1wLzHkn-4Z-3r7Pyypbfa373lWkz3PtM58zqKzmj8rhGg0DH3Oq_jIwF1MoKT2OGU4O7pz_xVE8vxBViF4")

	options = {data: {message: 'Order Successfully Placed' , title: 'EatLub' , redirect: 'Order Placed' , order_id: args.first.id }}
	response = fcm_driver.send(args.first.user.devices.where(device: 'Android').pluck(:token), options)
  end
end
