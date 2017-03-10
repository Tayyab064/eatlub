json.orders(@order) do |ord|
		json.id ord.id
		json.address ord.address
		json.status ord.status.capitalize
		json.notes ord.notes
		json.restaurant ord.restaurant.name
		json.items(ord.items) do |item|
			json.id item.id
			json.title item.orderable.name
			json.price item.orderable.price
			json.quantity item.quantity
		end
	end