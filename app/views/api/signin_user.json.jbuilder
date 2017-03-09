if @message.present?
	json.message @message
else
	json.user do
		json.email @user.email
		json.mobile_number @user.mobile_number
		json.name @user.name
		json.username @user.username
		json.verified @user.verified
		json.blocked @user.block
		json.token @user.token
	end
end