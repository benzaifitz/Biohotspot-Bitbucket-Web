json.array!(@jobs) do |job|
  json.extract! job, :id, :user_id, :offered_by_id, :status, :detail, :created_at, :updated_at
end
