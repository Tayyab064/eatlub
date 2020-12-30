class DispatchRiderJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    #rider = Location.all.near(args.first.address, 50, :units => :km)
    #rider.each do |loc|
    	
    #end

  require 'fcm'
	fcm_driver = FCM.new("AAAAnaUPlck:APA91bGk3JE9VrDJcsgd5hZtRNLsJ7Na6ZHaKCe-HzaCp-7I1CelElMCLr1wLzHkn-4Z-3r7Pyypbfa373lWkz3PtM58zqKzmj8rhGg0DH3Oq_jIwF1MoKT2OGU4O7pz_xVE8vxBViF4")

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
