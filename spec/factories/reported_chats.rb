# == Schema Information
#
# Table name: reported_chats
#
#  id             :integer          not null, primary key
#  chat_id        :integer
#  reported_by_id :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryGirl.define do
  factory :reported_chat do
    chat nil
  end

end
