json.extract! tariff, :id, :description, :weight, :distance, :duration, :price, :created_at, :updated_at
json.url tariff_url(tariff, format: :json)
