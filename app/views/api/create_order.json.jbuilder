if @message.present?
	json.message @message
else
	json.order do
		json.id @ord.id
		json.address @ord.address
		json.notes @ord.notes
		json.restaurant @ord.restaurant.name
		json.items(@ord.items) do |item|
			json.id item.id
			json.title item.orderable.name
			json.price item.orderable.price
			json.quantity item.quantity
		end
	end
end