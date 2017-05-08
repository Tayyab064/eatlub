json.orders do
	if @order_mon.present?
		json.array!(@order_mon) do |month, req|
			json.month month
			json.earning(req) do |ord|
				json.id ord.id
				json.date ord.created_at.strftime('%d/%m/%y')
				json.address ord.address
				json.notes ord.notes
				json.status ord.status
				json.assigned_at ord.assigned.present? ? ord.assigned.strftime('%R') : ''
				json.tip ord.tip
				json.user ord.user.email
			end
		end
	elsif @order_wee.present?
		json.array!(@order_wee) do |month, req|
			json.week month
			json.earning(req) do |ord|
				json.id ord.id
				json.date ord.created_at.strftime('%d/%m/%y')
				json.address ord.address
				json.notes ord.notes
				json.status ord.status
				json.assigned_at ord.assigned.present? ? ord.assigned.strftime('%R') : ''
				json.tip ord.tip
				json.user ord.user.email
			end
		end
	else
		json.array!(@order_dai) do |month, req|
			json.daily month
			json.earning(req) do |ord|
				json.id ord.id
				json.date ord.created_at.strftime('%d/%m/%y')
				json.address ord.address
				json.notes ord.notes
				json.status ord.status
				json.assigned_at ord.assigned.present? ? ord.assigned.strftime('%R') : ''
				json.tip ord.tip
				json.user ord.user.email
			end
		end
	end
end
