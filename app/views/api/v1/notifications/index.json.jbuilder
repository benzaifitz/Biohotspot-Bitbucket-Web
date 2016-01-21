json.array!(@notifications) do |notification|
  json.extract! notification, :id, :alert, :data, :created_at, :updated_at
  if notification.user.present?
    json.set! 'recipient' do
      json.extract! notification.user, :id, :first_name, :last_name, :username, :full_name
    end
  end
  if notification.sender.present?
    json.set! 'sender' do
      json.extract! notification.sender, :id, :first_name, :last_name, :username, :full_name
    end
  end
end