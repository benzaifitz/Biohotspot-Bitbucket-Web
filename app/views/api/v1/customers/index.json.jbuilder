json.array!(@customers) do |land_manager|
  json.extract! land_manager, :id
  json.url api_v1_customer_url(land_manager, format: :json)
end
