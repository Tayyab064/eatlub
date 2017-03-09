if @message.present?
	json.message @message
else
	json.restaurants(@restaurants) do |restaurant|
		json.id restaurant.id
		json.name restaurant.name
		json.opening_time restaurant.opening_time.strftime('%r')
		json.closing_time restaurant.closing_time.strftime('%r')
		json.about_us restaurant.about_us
		json.location restaurant.location
		json.distance restaurant.distance_from(@latlong).round(2)
		json.cuisine restaurant.cuisine
		json.type restaurant.typee
		json.status restaurant.status
		if restaurant.image_url.present?
			json.image restaurant.image_url.gsub(restaurant.image_url.split('/')[6], 'q_50')
		else
			json.image ''
		end
		json.popular restaurant.popular
	end
end