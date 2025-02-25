# MensaGes - No-frills ERP built on Rails to manage a courier agency.
# Copyright (C) 2025 Francisco Javier Fernández Martínez & Iván González Angullo
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the Affero GNU General Public License as published
# by the Free Software Foundation, either version 3 of the License, or any
# later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
# contact email - fran.fdezmtnez@gmail.com / iangullo@gmail.com
#
# Each Delivery belongs to a Customer, has one Courier, several Packages
class Delivery < ApplicationRecord
	belongs_to :customer
	belongs_to :courier
	belongs_to :tariff
	belongs_to :seller
	belongs_to :origin, class_name: 'Address'
	belongs_to :destination, class_name: 'Address'
	has_many :packages, dependent: :destroy

	# Add validations if needed
	validates :customer, :courier, :origin, :destination, :tariff, :seller, presence: true

	# A method to calculate the price of the delivery based on the tariff and other factors
	def calculate_price
		# Assuming tariffs have a base price, you can multiply or adjust this price based on weight, distance, or other parameters
		base_price = self.tariff.price
		#weight_factor = self.packages.sum(:weight) * 0.5 # Example weight factor
		#distance_factor = self.distance * 0.2 # Example distance factor

		#base_price + weight_factor + distance_factor
	end
end
