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
# frozen_string_literal: true

# TopbarComponent - dynamic display of application top bar as RubyUI component
module RubyUI
	class Topbar < Base
		def initialize(icon:, label:, buttons: [])
			@icon = icon
			@label = label
			@buttons = buttons
		end
	
		def view_template
			nav class: "w-full fixed bg-blue-900 top-0 left-0 right-0 z-10 h-15" do
				div class: "max-w-7xl mx-auto px-2 sm:px-6 lg:px-8 shadow" do
					div class: "relative flex items-center justify-between px-4 py-2" do
						left_section	# app icon & label
						mid_section		# regular menu buttons for wide screens
						right_section	# hamburger menu for narrow screens
					end
				end
				
				# Breadcrumbs
#				div class: "px-4 py-2 shadow" do
#					Breadcrumb(class: "text-sm text-gray-500 bg-gray-300")
#				end
			end
		end
		
		private
		# Icon and label
		def left_section
			div class: "flex items-center gap-2" do
				button class: "inline-flex" do
					img src: @icon, class: "h-8 w-8"
					if @label
						span class: "font-bold text-xl text-white ml-2" do
							plain @label
						end
					end
				end
			end
		end

		def mid_section
			div class: "flex-1 flex items-center justify-center hidden md:flex align-center" do
				@buttons.each do |button|
					if button[:options]
						render_dropdown(button)
					else
						Link(href: button[:href], variant: :ghost, class: "font-semibold text-gray-300") { button[:label] }
					end
				end
			end
		end

		def right_section
			div class: "absolute inset-y-0 right-0 flex items-center pr-2 md:hidden sm:static sm:inset-auto sm:ml-6 sm:pr-0" do
				render_dropdown({label: "Menu", options: @buttons})
			end
		end

		def render_dropdown(button, ham: false)
			DropdownMenu do
				DropdownMenuTrigger(class: 'w-full') do
					Button(variant: :ghost, class: "font-semibold text-gray-300") { button[:label] }
				end
				DropdownMenuContent do
					button[:options].each { |opt| DropdownMenuItem(href: opt[:href], class: "font-semibold text-gray-300") { opt[:label] } }
				end
			end
		end

		def theme_toggle
			ThemeToggle do |toggle|
				toggle.light_mode do
					Button(variant: :ghost, icon: true) do
						svg(xmlns: "http://www.w3.org/2000/svg",viewbox: "0 0 24 24", fill: "currentColor", class: "w-4 h-4") do |s|
							s.path(d: "M12 2.25a.75.75 0 01.75.75v2.25a.75.75 0 01-1.5 0V3a.75.75 0 01.75-.75zM7.5 12a4.5 4.5 0 119 0 4.5 4.5 0 01-9 0zM18.894 6.166a.75.75 0 00-1.06-1.06l-1.591 1.59a.75.75 0 101.06 1.061l1.591-1.59zM21.75 12a.75.75 0 01-.75.75h-2.25a.75.75 0 010-1.5H21a.75.75 0 01.75.75zM17.834 18.894a.75.75 0 001.06-1.06l-1.59-1.591a.75.75 0 10-1.061 1.06l1.59 1.591zM12 18a.75.75 0 01.75.75V21a.75.75 0 01-1.5 0v-2.25A.75.75 0 0112 18zM7.758 17.303a.75.75 0 00-1.061-1.06l-1.591 1.59a.75.75 0 001.06 1.061l1.591-1.59zM6 12a.75.75 0 01-.75.75H3a.75.75 0 010-1.5h2.25A.75.75 0 016 12zM6.697 7.757a.75.75 0 001.06-1.06l-1.59-1.591a.75.75 0 00-1.061 1.06l1.59 1.591z")
						end
					end
				end
				toggle.dark_mode do
					Button(variant: :ghost, icon: true) do
						svg(xmlns: "http://www.w3.org/2000/svg", viewbox: "0 0 24 24", fill: "currentColor", class: "w-4 h-4") do |s|
							s.path(fill_rule: "evenodd", d: "M9.528 1.718a.75.75 0 01.162.819A8.97 8.97 0 009 6a9 9 0 009 9 8.97 8.97 0 003.463-.69.75.75 0 01.981.98 10.503 10.503 0 01-9.694 6.46c-5.799 0-10.5-4.701-10.5-10.5 0-4.368 2.667-8.112 6.46-9.694a.75.75 0 01.818.162z", clip_rule: "evenodd")
						end
					end					
				end
			end
		end	
	end
end