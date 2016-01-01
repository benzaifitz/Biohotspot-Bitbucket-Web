json.array! @staffers do |staffer|
  json.extract! staffer, :id, :email, :first_name, :last_name, :username, :company, :rating, :created_at, :updated_at
  json.profile_picture_url staffer.profile_picture_url
end