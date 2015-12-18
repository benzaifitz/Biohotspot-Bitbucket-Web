json.array!(@customers) do |customer|
  json.extract! customer, :id
  json.url api_v1_customer_url(customer, format: :json)
end
