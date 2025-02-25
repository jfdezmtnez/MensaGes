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
# Manage People objects - linked to all other Classes bound to a Person (Courier, Company, etc)
require 'phonelib'

class Person < ApplicationRecord
	belongs_to :address
	has_many :couriers
	has_many :sellers
	validates :cif, presence: true, uniqueness: { case_sensitive: false }
	validates :name, :surname1, presence: true
	validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
	validates :phone, format: { with: /\A\+?\d{7,15}\z/, message: "must be a valid phone number" }, allow_blank: true

	before_validation :normalize_fields

	def formatted_phone(user_country)
		return phone if phone.blank?

		parsed_phone = Phonelib.parse(phone)

		if parsed_phone.valid? && parsed_phone.country == user_country
			parsed_phone.national  # Show local format
		else
			parsed_phone.international  # Show international format (+CountryCode)
		end
	end

	private

	def normalize_fields
		self.cif = cif.strip.upcase if cif.present?
		self.name = name.strip.titleize if name.present?
		self.surname1 = surname1.strip.titleize if surname1.present?
		self.surname2 = surname2.strip.titleize if surname2.present?
		self.email = email.strip.downcase if email.present?
		self.phone = normalize_phone(phone) if phone.present?
	end

	def normalize_phone(phone)
		parsed_phone = Phonelib.parse(phone)

		if parsed_phone.valid?
			parsed_phone.e164  # Store in E.164 international format (+CountryCodeNumber)
		else
			phone.gsub(/[^+\d]/, '')  # Fallback: Strip invalid characters but keep the +
		end
end
