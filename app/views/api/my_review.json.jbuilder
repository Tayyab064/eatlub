json.review(@reviews) do |review|

	json.rating review.rating
	json.quality review.quality
	json.price review.price
	json.punctuality review.punctuality
	json.courtesy review.courtesy
	json.summary review.summary
	json.deliverable review.reviewable.name
	json.reviewer review.reviewer.email

end