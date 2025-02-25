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
# Migration creates invoices table
class CreateInvoices < ActiveRecord::Migration[8.0]
	def change
		create_table :invoices do |t|
			t.references :customer, null: false, foreign_key: true
			t.string :invoice_number, null: false, unique: true
			t.date :issue_date, null: false
			t.date :due_date
			t.decimal :total_amount, precision: 10, scale: 2, default: 0.0
			t.string :status, default: "pending"
			t.timestamps
			t.string :remarks

			t.timestamps
		end
	end
end
