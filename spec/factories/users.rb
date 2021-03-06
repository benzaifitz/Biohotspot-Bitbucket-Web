# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  eula_id                :integer
#  first_name             :string
#  last_name              :string
#  company                :string
#  rating                 :decimal(, )      default(0.0)
#  status                 :integer          default(0), not null
#  user_type              :integer          default(0), not null
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  tokens                 :json
#  number_of_ratings      :integer          default(0)
#  uuid_iphone            :string
#

FactoryGirl.define do
  factory :user do
    confirmed_at Time.now
    name "Test User"
    sequence(:username) {|n| "testuser#{n}"}
    company "Test Company"
    sequence(:email) {|n| "test#{n}@dapperapps.com.au"}
    password "please123"
    eula_id 1
    privacy_id 1
    factory :project_manager do
      user_type 'project_manager'
    end

    factory :admin do
      user_type 'administrator'
    end

    factory :land_manager do
      user_type 'land_manager'
    end

  end
end
