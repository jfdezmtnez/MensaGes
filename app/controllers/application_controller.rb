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
# Common methods for all controllers
class ApplicationController < ActionController::Base
	include Authentication
	include RubyUI
	# Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
	allow_browser versions: :modern
	before_action :set_topbar
	around_action :switch_locale

	# switch app locale
	def switch_locale(&action)
#		locale   = (params[:locale] || current_user&.locale || I18n.default_locale)
		locale   = (params[:locale] || I18n.default_locale)
		I18n.with_locale(locale, &action)
	end

	# sets the app topbar, always first thing to do
	def set_topbar
		@topbar = Topbar.new(
			icon: "icon.svg",
			label: "MensaGes",
			buttons: [
				{ label: I18n.t("customer.many"), href: customers_path },
				{ label: I18n.t("delivery.many"), href: deliveries_path },
				{ label: I18n.t("courier.many"), href: couriers_path },
				{ label: I18n.t("seller.many"), href: sellers_path },
				{ label: I18n.t("invoice.many"), href: invoices_path },
			]
		)
	end
end
