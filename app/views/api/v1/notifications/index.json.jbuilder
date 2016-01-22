json.array!(@notifications) do |notification|
  json.extract! notification, :id, :alert, :data, :created_at, :updated_at
  if notification.sender.present?
    json.set! 'sender' do
      json.extract! notification.sender, :id, :first_name, :last_name, :username, :full_name
      json.profile_picture_url notification.sender.profile_picture_url
    end
  end
end