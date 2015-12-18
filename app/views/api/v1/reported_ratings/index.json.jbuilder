json.array!(@api_v1_reported_ratings) do |api_v1_reported_rating|
  json.extract! api_v1_reported_rating, :id
  json.url api_v1_reported_rating_url(api_v1_reported_rating, format: :json)
end
