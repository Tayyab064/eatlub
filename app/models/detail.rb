class Detail < ApplicationRecord
	belongs_to :rider, class_name: 'User'

	enum status: [:free , :ongoing ]
	enum vehicle: [:scooter , :car , :bicycle ]
end
