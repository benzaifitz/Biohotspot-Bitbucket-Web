FactoryGirl.define do
  factory :submission do
    survey_number "MyString"
    submitted_by 1
    lat false
    long false
    sub_category nil
    rainfall "MyString"
    humidity "MyString"
    temperature "MyString"
    health_score 1.5
    live_leaf_cover "MyString"
    live_branch_stem "MyString"
    stem_diameter 1.5
  end
end
