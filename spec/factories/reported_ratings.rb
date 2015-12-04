# == Schema Information
#
# Table name: reported_ratings
#
#  id             :integer          not null, primary key
#  rating_id      :integer
#  reported_by_id :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryGirl.define do
  factory :reported_rating do
    rating nil
  end

end
