json.deliverable(@deliverable) do |deli|
	json.id deli.id
	json.name deli.name
	json.deliverable_type deli.deliver_category.name
	if deli.cover_url.present?
		json.image deli.cover_url.gsub(deli.cover_url.split('/')[6], 'q_50')
	else
		json.image ''
	end
end

json.restaurant(@restaurant) do |deli|
	json.id deli.id
	json.name deli.name
	if deli.cover_url.present?
		json.image deli.cover_url.gsub(deli.cover_url.split('/')[6], 'q_50')
	else
		json.image ''
	end
end