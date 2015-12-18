json.array! @staffers do |staffer|
  json.extract! staffer, :id, :email, :full_name, :username
  json.profile_picture_url do |u|
    u.profile_picture_url
  end
end