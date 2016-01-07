json.array!(@jobs) do |job|
  json.extract! job, :id, :status, :detail, :created_at, :updated_at
  if job.offered_by.present? && current_user.staff?
    json.set! 'offered_by' do |j|
      json.extract! job.offered_by, :id, :full_name, :first_name, :last_name, :username, :company, :rating
    end
  end
  if job.user.present? && current_user.customer?
    json.set! 'offered_to' do |j|
      json.extract! job.user, :id, :full_name, :first_name, :last_name, :username, :company, :rating
    end
  end
end
