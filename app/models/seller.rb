class Seller < ApplicationRecord
	belongs_to :person
	belongs_to :company
	has_many :deliveries # Link to deliveries

	validates :person, presence: true
	validates :company, presence: true
end
