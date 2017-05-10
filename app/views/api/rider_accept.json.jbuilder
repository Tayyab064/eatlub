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

		bran = @ord.ordera.branches.near( @ord.address, 20).first
		if bran.present?
			json.restaurant_location bran.address
		else
			json.restaurant_location ''
		end
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