json.array!(@api_v1_ratings) do |api_v1_rating|
  json.extract! api_v1_rating, :id
  json.url api_v1_rating_url(api_v1_rating, format: :json)
end
