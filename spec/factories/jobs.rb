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
#

FactoryGirl.define do
  factory :job do
    
  end

end
