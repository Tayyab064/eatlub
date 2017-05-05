if @message.present?
	json.message @message
else
	json.id @ord.id
	json.address @ord.address
	json.status @ord.status.capitalize
	json.notes @ord.notes
	json.user @ord.user.username
	if @ord.ordera.present?
	json.restaurant @ord.ordera.name
	json.restaurant_location @ord.ordera.location
	else
	json.restaurant ''
	json.restaurant_location ''
	end
	json.items(@ord.items) do |item|
		json.id item.id
		json.title item.orderable.name
		json.price item.orderable.price
		json.quantity item.quantity
	end
end