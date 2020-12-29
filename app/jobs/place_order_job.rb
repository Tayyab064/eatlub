class PlaceOrderJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    require 'fcm'
	fcm_driver = FCM.new("AIzaSyB73QFyyZBjYE3Bb5gS9wsd4EWui6nHoIo")

	options = {data: {message: 'Order Successfully Placed' , title: 'EatLub' , redirect: 'Order Placed' , order_id: args.first.id }}
	response = fcm_driver.send(args.first.user.devices.where(device: 'Android').pluck(:token), options)
  end
end
