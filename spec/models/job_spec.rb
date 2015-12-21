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

require 'rails_helper'

describe Job do

  let(:statuses_order) { %w{offered completed accepted cancelled rejected withdrawn} }

  describe '#job' do
    it 'has a valid factory' do
      expect(build(:job)).to be_valid
    end

    it 'is invalid without a offered to user' do
      expect(build(:job, user: nil)).to_not be_valid
    end

    it 'is invalid without a offered by user' do
      expect(build(:job, offered_by_id: nil)).to_not be_valid
    end

    it 'is invalid without a status' do
      expect(build(:job, status: nil)).to_not be_valid
    end

    it 'is invalid without a description' do
      expect(build(:job, description: nil)).to_not be_valid
    end
  end

  # describe 'ActiveModel validations' do
  #   let(:user) { build(:user) }
  #   # Format validations
  #   it { should allow_value("zahid@dapperapps.com.au").for(:email) }
  #   it { should_not allow_value("base@dapperapps").for(:email) }
  #   it { should_not allow_value("blah").for(:email) }
  #   it { should allow_value("zahidali").for(:username) }
  #   it { should_not allow_value("zahid ali").for(:username) }
  #
  #   # Basic validations
  #   it { should validate_presence_of(:email).with_message(/can't be blank/) }
  #   it { should validate_presence_of(:username).with_message(/can't be blank/) }
  #   it { should validate_uniqueness_of(:username) }
  #   it {expect(User.user_types.keys.length).to eq(user_types_order.length)}
  #   it {expect(User.device_types.keys.length).to eq(device_types_order.length)}
  #   it {expect(User.statuses.keys.length).to eq(statuses_order.length)}
  # end
  #

  describe '#status' do
    it 'has the right index' do
      statuses_order.each_with_index do |item, index|
        expect(described_class.statuses[item]).to eq index
      end
    end
  end

  describe 'ActiveRecord associations' do
    let(:job) { build(:job) }
    it { should belong_to(:user) }
    it { should belong_to(:offered_by) }
  end

  context 'callbacks' do
    let(:job) { create(:job) }
    it { should callback(:add_to_mailchimp).after(:create) }
    it { should callback(:log_user_events).after(:update) }
    it { should callback(:update_on_mailchimp).after(:update) }
    it { should callback(:delete_from_mailchimp).after(:destroy) }
  end

end
