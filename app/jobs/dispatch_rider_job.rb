class DispatchRiderJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    #rider = Location.all.near(args.first.address, 50, :units => :km)
    #rider.each do |loc|
    	
    #end

    require 'gcm'
	gcm_driver = GCM.new("AIzaSyB73QFyyZBjYE3Bb5gS9wsd4EWui6nHoIo")

	options = {data: {message: 'Rider needed' , title: 'Deliverush' , redirect: 'Rider Call' , pickup_location: args.first.restaurant.location , destination: args.first.address , order_id: args.first.id }}
	response = gcm_driver.send(Device.where(device: 'Android').pluck(:token), options)


 end
end
