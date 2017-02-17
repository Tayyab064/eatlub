json.extract! restaurant, :id, :name, :opening_time, :closing_time, :location, :cuisine, :created_at, :updated_at
json.url restaurant_url(restaurant, format: :json)