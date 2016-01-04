# == Schema Information
#
# Table name: chats
#
#  id              :integer          not null, primary key
#  message         :text
#  conversation_id :integer
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  status          :integer          default(0), not null
#  from_user_id    :integer

FactoryGirl.define do
  factory :chat do
    message "Test Message"
    conversation
    user
    association :from_user, factory: :user
    status 0
  end
end