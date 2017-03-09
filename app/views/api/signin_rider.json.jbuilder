if @message.present?
	json.message @message
else
	json.rider do
		json.email @rider.email
		json.mobile_number @rider.mobile_number
		json.name @rider.name
		json.username @rider.username
		json.verified @rider.verified
		json.blocked @rider.block
		json.token @rider.token
	end
end