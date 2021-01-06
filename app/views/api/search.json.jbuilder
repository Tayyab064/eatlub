if @message.present?
	json.message @message
elsif @branches.present?
	
	json.restaurants(@branches) do |branch|

		restaurant = branch.deliverable

		json.id restaurant.id
		json.name restaurant.name
		json.opening_time restaurant.opening_time.strftime('%r')
		json.closing_time restaurant.closing_time.strftime('%r')
		json.about_us restaurant.about_us
		json.delivery_time "#{restaurant.delivery_time.to_s} mins to #{(restaurant.delivery_time + 15).to_s} mins"



		if @latlong.present?
			bran  = branch.distance_to(@latlong).round
		else
			bran = 0
		end

		json.location branch.address
		json.distance bran

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


		if restaurant.menu.present?
			json.section(restaurant.menu.sections) do |section|
				json.food_items(section.food_items) do |food|
					if food.publish
						json.id food.id
						json.name food.name

						if food.image_url.present?
							json.image food.image_url.gsub(food.image_url.split('/')[6], 'q_50')
						else
							json.image ''
						end
					end
				end
			end
		else
			json.section ''
		end
	end

else
	json.restaurants(@restaurants) do |restaurant|

		branch = restaurant.branches.first

		json.id restaurant.id
		json.name restaurant.name
		json.opening_time restaurant.opening_time.strftime('%r')
		json.closing_time restaurant.closing_time.strftime('%r')
		json.about_us restaurant.about_us
		json.delivery_time "#{restaurant.delivery_time.to_s} mins to #{(restaurant.delivery_time + 15).to_s} mins"



		if @latlong.present?
			bran  = branch.distance_to(@latlong).round
		else
			bran = 0
		end

		json.location branch.address
		json.distance bran

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


		if restaurant.menu.present?
			json.section(restaurant.menu.sections) do |section|
				json.food_items(section.food_items) do |food|
					if food.publish
						json.id food.id
						json.name food.name

						if food.image_url.present?
							json.image food.image_url.gsub(food.image_url.split('/')[6], 'q_50')
						else
							json.image ''
						end
					end
				end
			end
		else
			json.section ''
		end



	end

end