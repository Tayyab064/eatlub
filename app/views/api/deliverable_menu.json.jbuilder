if @message.present?
	json.message @message
else
	json.restaurant do
		json.id @restaurant.id
		json.name @restaurant.name
		json.category @restaurant.deliver_category.name
		json.opening_time @restaurant.opening_time.strftime('%r')
		json.closing_time @restaurant.closing_time.strftime('%r')
		json.about_us @restaurant.about_us
		json.delivery_time "#{@restaurant.delivery_time.to_s} mins to #{(@restaurant.delivery_time + 15).to_s} mins"
		
		bran = @restaurant.branches.near( @latlong, 20).first
		if bran.present?
			json.location bran.address
			json.distance bran.distance_from(@latlong).round(2)
		else
			json.location ''
			json.distance 0.0
		end

		json.status @restaurant.status
		if @restaurant.image_url.present?
			json.image @restaurant.image_url.gsub(@restaurant.image_url.split('/')[6], 'q_50')
		else
			json.image ''
		end
		json.popular @restaurant.popular
		if @restaurant.menu.present?
			json.section(@restaurant.menu.sections) do |section|
				json.title section.title
				json.food_items(section.food_items) do |food|
					if food.publish
						json.id food.id
						json.name food.name
						json.price food.price

						if food.image_url.present?
							json.image food.image_url.gsub(food.image_url.split('/')[6], 'q_50')
						else
							json.image ''
						end

						json.ingredients(food.ingredients) do |ingred|
							json.id ingred.id
							json.title ingred.title
							json.price ingred.price
						end

						json.options(food.options) do |opti|
							json.id opti.id
							json.title opti.title
							json.price opti.price
						end
					end
				end
			end
		else
			json.section @restaurant.branches.near( @latlong, 20).limit(0)
		end
	end
end