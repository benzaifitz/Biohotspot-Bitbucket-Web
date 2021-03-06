json.array!(@conversations) do |conversation|
  json.extract! conversation, :id, :name, :conversation_type, :last_message, :is_abandoned, :created_at, :updated_at
  json.conversation_type_num conversation[:conversation_type]
  if conversation.recipient.present? && conversation.user_id != current_user.id
    json.set! 'correspondent' do
      json.extract! conversation.recipient, :id, :full_name, :first_name, :last_name, :username, :company, :rating
    end
  end
  if conversation.from_user.present? && conversation.from_user_id != current_user.id
    json.set! 'correspondent' do
      json.extract! conversation.from_user, :id, :full_name, :first_name, :last_name, :username, :company, :rating
    end
  end
end