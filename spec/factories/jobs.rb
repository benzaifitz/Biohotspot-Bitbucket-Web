# == Schema Information
#
# Table name: jobs
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  offered_by :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :integer          default(0)
#  description :string

FactoryGirl.define do
  factory :job do
    user
    association :offered_by, factory: :customer
    status 0
    detail 'Some random string from Dapper Apps'
  end

end
