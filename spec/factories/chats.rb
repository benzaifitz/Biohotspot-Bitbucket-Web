# == Schema Information
#
# Table name: chats
#
#  id              :integer          not null, primary key
#  message         :text
#  conversation_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  status          :integer          default(0), not null
#  from_user_id    :integer

FactoryGirl.define do
  factory :chat do
    message "Test Message"
    conversation
    association :from_user, factory: :user
    status 0
    is_read false
  end
end