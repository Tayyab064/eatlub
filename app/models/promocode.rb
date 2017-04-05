class Promocode < ApplicationRecord
	validates :promocode, length: { minimum: 2 }
	validates_numericality_of :amount, greater_than: 0	
end
