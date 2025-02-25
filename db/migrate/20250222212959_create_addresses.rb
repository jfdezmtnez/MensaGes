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
# Migration creates Address objects in database
class CreateAddresses < ActiveRecord::Migration[8.0]
	def change
		create_table :addresses do |t|
			t.string :street, null: false
			t.string :number
			t.string :floor
			t.string :city, null: false
			t.string :state
			t.string :postal_code, null: false
			t.string :country, null: false

			t.timestamps
		end
		
		add_index :addresses, [:city, :postal_code, :street, :number, :floor, :country], 
							unique: true, 
							name: 'index_addresses_on_unique_fields'
	end
end
