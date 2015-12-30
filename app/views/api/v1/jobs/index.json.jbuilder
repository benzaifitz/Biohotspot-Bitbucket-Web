json.array!(@jobs) do |job|
  json.extract! job, :id, :status, :detail, :created_at, :updated_at
  json.set! 'offered_by' do |j|
    json.extract! job.offered_by, :id, :first_name, :last_name, :username, :company, :rating
  end
  json.set! 'offered_to' do |j|
    json.extract! job.user, :id, :first_name, :last_name, :username, :company, :rating
  end
end
