class DispatchRiderJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    rider = Location.all.near(args.first.address, 50, :units => :km)
    rider.each do |loc|
    	
    end
  end
end
