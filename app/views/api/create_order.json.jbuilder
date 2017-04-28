if @message.present?
	json.message @message
else
	json.order do
		json.id @ord.id
		json.address @ord.address
		json.notes @ord.notes
		if @ord.ordera.present?
		json.restaurant @ord.ordera.name
		else
		json.restaurant ''
		end
		json.items(@ord.items) do |item|
			json.id item.id
			json.title item.orderable.name
			
			final_pri = 0.0

			json.quantity item.quantity
			json.ingredients(item.ingredients) do |ingre|
				if Ingredient.exists?(ingre)
					ing = Ingredient.find(ingre)
					json.title ing.title
					json.price ing.price
					final_pri = final_pri + ing.price.to_f
				else
					json.title ''
					json.price 0.0
				end
			end
			json.option(item.option) do |opti|
				if Option.exists?(opti)
					ing = Option.find(opti)
					json.title ing.title
					json.price ing.price
					final_pri = final_pri + ing.price.to_f
				else
					json.title ''
					json.price 0.0
				end
			end

			final_pri = final_pri + item.orderable.price
			final_pri = final_pri * item.quantity

			json.price final_pri.round(2)
		end
	end
end