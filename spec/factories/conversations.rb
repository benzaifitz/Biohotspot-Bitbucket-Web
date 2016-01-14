# == Schema Information
#
# Table name: conversations
#
#  id           :integer          not null, primary key
#  name         :string
#  user_id      :integer
#  from_user_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  last_message :text
#  last_user_id :integer
#

FactoryGirl.define do
  factory :conversation do
    name "MyString"
    association :recipient, factory: :user
    association :from_user, factory: :user
  end
end
