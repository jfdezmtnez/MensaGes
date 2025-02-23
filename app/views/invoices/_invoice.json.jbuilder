json.extract! invoice, :id, :issued, :code, :charge, :remarks, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
