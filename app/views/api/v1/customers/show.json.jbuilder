json.extract! @land_manager, :id, :first_name, :last_name, :full_name, :rating, :company, :email, :eula_id, :created_at, :updated_at
json.profile_picture_url @land_manager.profile_picture_url
json.set! 'ratings' do
  json.array!(@land_manager.rated_on_ratings) do |rated_on_ratings|
    json.extract! rated_on_ratings, :id, :rating, :comment, :created_at
  end
end