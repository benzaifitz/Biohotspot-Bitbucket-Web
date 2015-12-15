json.array!(@blocked_users) do |blocked_user|
  json.extract! blocked_user.user, :id, :first_name, :last_name, :company, :email, :created_at, :updated_at
end
