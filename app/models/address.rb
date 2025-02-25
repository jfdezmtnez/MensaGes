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
# Object to manage phsyical addresses (for People and Deliveries)
class Address < ApplicationRecord
	has_many :people
	has_many :origin_deliveries, class_name: 'Delivery', foreign_key: 'origin_id'
	has_many :destination_deliveries, class_name: 'Delivery', foreign_key: 'destination_id'
	validates :street, :number, :city, :postal_code, :country, presence: true
	validates :floor, uniqueness: { scope: [:city, :postal_code, :street, :number, :country], allow_nil: true }
	validates :street, :number, :city, :postal_code, :country, uniqueness: { scope: :floor, message: "Address already exists" }

	before_validation :normalize_fields

	private

	def normalize_fields
		self.street = street.strip.titleize if street.present?
		self.city = city.strip.titleize if city.present?
		self.country = country.strip.upcase if country.present?
	end
end
