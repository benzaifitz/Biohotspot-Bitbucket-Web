# == Schema Information
#
# Table name: ratings
#
#  id          :integer          not null, primary key
#  rating      :decimal(, )
#  comment     :text
#  user_id     :integer
#  rated_on_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  status      :integer          default(0), not null
#

FactoryGirl.define do
  factory :rating do
    rating 5.00
    user
    association :rated_on, factory: :user
    status 0
  end

end
