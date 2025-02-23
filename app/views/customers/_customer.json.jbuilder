json.extract! customer, :id, :person_id, :settings, :created_at, :updated_at
json.url customer_url(customer, format: :json)
