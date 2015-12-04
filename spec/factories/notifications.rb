# == Schema Information
#
# Table name: notifications
#
#  id                :integer          not null, primary key
#  subject           :string
#  message           :text
#  user_id           :integer
#  sent_by_id        :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  notification_type :integer          default(0), not null
#  user_type         :integer          default(0), not null
#

FactoryGirl.define do
  factory :notification do
    subject "MyString"
  end

end
