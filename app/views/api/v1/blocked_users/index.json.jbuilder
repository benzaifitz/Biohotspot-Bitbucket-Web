json.array!(@blocked_users) do |blocked_user|
  if blocked_user.user.present?
    json.extract! blocked_user.user, :id, :full_name,:first_name, :last_name, :company, :email, :rating, :status, :created_at, :updated_at
    json.profile_picture_url blocked_user.user.profile_picture_url
  end
end
