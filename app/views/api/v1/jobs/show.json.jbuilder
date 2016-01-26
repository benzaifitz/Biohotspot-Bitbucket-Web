json.extract! @job, :id, :user_id, :offered_by_id, :detail, :status, :created_at, :updated_at
json.status_num @job[:status]
if @job.offered_by.present? && current_user.staff?
  json.set! 'offered_by' do |j|
    json.extract! @job.offered_by, :id, :full_name, :first_name, :last_name, :username, :company, :rating
    json.profile_picture_url @job.offered_by.profile_picture_url
  end
end
if @job.user.present? && current_user.customer?
  json.set! 'offered_to' do |j|
    json.extract! @job.user, :id, :full_name, :first_name, :last_name, :username, :company, :rating
    json.profile_picture_url @job.user.profile_picture_url
  end
end