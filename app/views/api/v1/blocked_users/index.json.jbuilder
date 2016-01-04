json.array!(@blocked_users) do |blocked_user|
  json.extract! blocked_user.user, :id, :full_name,:first_name, :last_name, :company, :email, :rating, :status, :created_at, :updated_at
end
