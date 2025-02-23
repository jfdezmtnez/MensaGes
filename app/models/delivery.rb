class Delivery < ApplicationRecord
  belongs_to :customer
  belongs_to :courier
  belongs_to :tariff
end
