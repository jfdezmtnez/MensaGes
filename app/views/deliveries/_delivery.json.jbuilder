json.extract! delivery, :id, :customer_id, :courier_id, :pickup, :delivered, :tariff_id, :invoiced, :reimburse, :created_at, :updated_at
json.url delivery_url(delivery, format: :json)
