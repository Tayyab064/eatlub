if @message.present?
	json.message @message
else
	json.restaurants(@restaurants) do |restaurant|
		json.id restaurant.id
		json.name restaurant.name
		json.opening_time restaurant.opening_time.strftime('%r')
		json.closing_time restaurant.closing_time.strftime('%r')
		json.about_us restaurant.about_us
		json.delivery_time "#{restaurant.delivery_time.to_s} mins to #{(restaurant.delivery_time + 15).to_s} mins"

		bran = restaurant.branches.first



		#bran_old = restaurant.branches.near( @latlong, 20).first
		#bran_old_distance = (bran.distance_from(@latlong)*1.60934).round(2)


		

		json.location bran.address
		json.distance 4

		json.status restaurant.status
		if restaurant.image_url.present?
			json.image restaurant.image_url.gsub(restaurant.image_url.split('/')[6], 'q_50')
		else
			json.image ''
		end
		if restaurant.cover.present?
			json.cover_image restaurant.cover_url.gsub(restaurant.cover_url.split('/')[6], 'q_50')
		else
			json.cover_image ''
		end
		json.popular restaurant.popular
	end

	json.popular(@popular) do |res|
		json.id res.id
		json.name res.name
		if res.cover.present?
			json.image res.cover_url.gsub(res.cover_url.split('/')[6], 'q_50')
		else
			json.image ''
		end
	end
end