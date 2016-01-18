json.extract! @staff, :id, :first_name, :last_name, :full_name, :rating, :company, :email, :eula_id, :created_at, :updated_at
json.profile_picture_url @staff.profile_picture_url
json.set! 'ratings' do
  json.array!(@staff.rated_on_ratings) do |rated_on_ratings|
    json.extract! rated_on_ratings, :id, :rating, :comment, :created_at
  end
end