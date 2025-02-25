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
# Manage currently valid Tariffs for a Company
class Tariff < ApplicationRecord
	belongs_to :company

	# Validation for presence of essential fields
	validates :company, presence: true
	validates :description, presence: true
	validates :price, presence: true
	validates :weight, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
	validates :distance, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
	validates :duration, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
