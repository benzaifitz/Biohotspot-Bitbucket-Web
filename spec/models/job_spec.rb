# == Schema Information
#
# Table name: jobs
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  offered_by_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  status        :integer          default(0)
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

    it 'is invalid without a detail' do
      expect(build(:job, detail: nil)).to_not be_valid
    end
  end

  describe 'ActiveModel validations' do
    let(:job) { build(:job) }
    # Basic validations
    it { should validate_presence_of(:user_id).with_message(/can't be blank/) }
    it { should validate_presence_of(:offered_by_id).with_message(/can't be blank/) }
    it { should validate_presence_of(:status).with_message(/can't be blank/) }
    it { should validate_presence_of(:detail).with_message(/can't be blank/) }
    it {expect(Job.statuses.keys.length).to eq(statuses_order.length)}
    describe 'Custom Validations' do
      it 'can only have offered by user as a customer' do
        staff1 = create(:staff)
        staff2 = create(:staff)
        job = Job.create(detail: 'Test', user: staff1, offered_by: staff2)
        expect(job.errors.messages[:offering]).to eq ["user must be a customer."]
      end
      it 'can only have offered to user as a staff' do
        customer1 = create(:customer)
        customer2 = create(:staff)
        job = Job.create(detail: 'Test', user: customer1, offered_by: customer2)
        expect(job.errors.messages[:offered]).to eq ["user must be staff."]
      end
    end
  end


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
    it { should callback(:is_user_allowed_to_set_job_status).before(:update) }
    it { should callback(:send_push_notification_to_customer).after(:update) }
    it { should callback(:send_push_notification_to_staff).after(:update) }
  end

end
