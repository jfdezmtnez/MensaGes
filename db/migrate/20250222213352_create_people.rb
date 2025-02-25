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
# Migration to create People table
class CreatePeople < ActiveRecord::Migration[8.0]
	def change
		create_table :people do |t|
			t.string :nick
			t.string :name
			t.string :surname1
			t.string :surname2
			t.date :birthday
			t.string :cif, null: false, unique: true
			t.string :phone
			t.string :email
			t.references :address, null: false, foreign_key: true
			t.jsonb :settings, default: {}

			t.timestamps
		end

		add_index :people, :cif, unique: true  # Adds a unique index for faster lookups
	end
end
