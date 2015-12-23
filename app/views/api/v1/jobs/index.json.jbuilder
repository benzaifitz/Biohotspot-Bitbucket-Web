json.array!(@jobs) do |job|
  json.extract! job, :id, :status, :detail, :created_at, :updated_at
  [:offered_by, :user].each do |u|
    json.set! u.to_s do
      json.extract! job.send(u), :id, :first_name, :last_name, :username
    end
  end
end
