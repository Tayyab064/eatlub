json.deliverables(@cat) do |cate|
	json.name cate.name
	if cate.name == 'grocery'
	    json.title 'Grocery'
	elsif cate.name == 'petsfood'
	    json.title 'Pets Food'
	elsif cate.name == 'coffeeshop'
	    json.title 'Coffee Shop'
	elsif cate.name == 'healthbeauty'
	    json.title 'Health & Beauty'
	elsif cate.name == 'gifts'
	    json.title 'Gift Shop'
	else
	    json.title cate.name.capitalize
	end
	json.description cate.description
	if cate.image_url.present?
		json.image cate.image_url.gsub(cate.image_url.split('/')[6], 'q_50')
	else
		json.image ''
	end
end

json.restaurant do
	json.name 'restaurants'
	json.title 'Restaurant'
	json.description 'We can deliver food to your place.'
	json.image 'http://www.ghmhotels.com/wp-content/uploads/CMU-Dining-The-Beach-Restaurant-Interior.jpg'
end