# == Schema Information
#
# Table name: privacies
#
#  id           :integer          not null, primary key
#  privacy_text :text
#  is_latest    :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :privacy do
    privacy_text 'Some really long provacy text'
  end

end
