json.review do

	json.rating @review.rating
	json.quality @review.quality
	json.price @review.price
	json.punctuality @review.punctuality
	json.courtesy @review.courtesy
	json.summary @review.summary

end