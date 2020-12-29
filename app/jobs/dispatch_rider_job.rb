class DispatchRiderJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    #rider = Location.all.near(args.first.address, 50, :units => :km)
    #rider.each do |loc|
    	
    #end

  require 'fcm'
	fcm_driver = FCM.new("AIzaSyB73QFyyZBjYE3Bb5gS9wsd4EWui6nHoIo")

	options = {data: {message: 'Rider needed' , title: 'EatLub' , redirect: 'Rider Call' , pickup_location: args.first.ordera.location , destination: args.first.address , order_id: args.first.id }}
	response = fcm_driver.send(Device.where(device: 'Android').pluck(:token), options)


  #apn = Houston::Client.development
  #apn.certificate = File.read("#{Rails.root}/config/rider_development.pem") # certificate from prerequisites
  #apn.passphrase = "123456"

  #Device.where(device: 'IOS').pluck(:token).each do |tok|
  #  notification = Houston::Notification.new(device: tok)
  #  notification.alert = 'Rider needed'
    # take a look at the docs about these params
  #  notification.badge = 1
  #  notification.sound = "sosumi.aiff"
  #  notification.custom_data = options
  #  apn.push(notification)
  #end


 end
end
