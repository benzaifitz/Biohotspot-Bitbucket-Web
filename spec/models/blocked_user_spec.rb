# == Schema Information
#
# Table name: blocked_users
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  blocked_by :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'


describe BlockedUser do

  describe '#blocked user' do
    it 'has a valid factory' do
      expect(build(:blocked_user)).to be_valid
    end

    it 'is invalid without a blocked user id' do
      expect(build(:blocked_user, user_id: nil)).to_not be_valid
    end

    it 'is invalid without a blocked by user id' do
      expect(build(:blocked_user, blocked_by_id: nil)).to_not be_valid
    end
  end

  describe 'ActiveModel validations' do
    let(:blocked_user) { build(:blocked_user) }
    # Basic validations
    it { expect(create(:blocked_user)).to validate_uniqueness_of(:user_id).scoped_to(:blocked_by_id) }
    it { should validate_presence_of(:user_id).with_message(/can't be blank/) }
    it { should validate_presence_of(:blocked_by_id).with_message(/can't be blank/) }
  end

  describe 'ActiveRecord associations' do
    let(:blocked_user) { build(:blocked_user) }
    it { should belong_to(:user) }
    it { should belong_to(:blocked_by) }
  end

  describe 'Callbacks' do
    it "should cancel all jobs of associated users if staff blocks a customer" do
      add_rpush_app
      customer = create(:customer)
      staff = create(:staff)
      job = create(:job, offered_by_id: customer.id, user_id: staff.id, status: 'offered')
      blocked_user = create(:blocked_user, blocked_by_id: staff.id, user_id: customer.id)
      job.reload
      expect(job.status).to eq 'cancelled'
    end

    it "should cancel all jobs of associated users if customer blocks a staff" do
      add_rpush_app
      customer = create(:customer)
      staff = create(:staff)
      job = create(:job, offered_by_id: customer.id, user_id: staff.id, status: 'offered')
      blocked_user = create(:blocked_user, blocked_by_id: customer.id, user_id: staff.id)
      job.reload
      expect(job.status).to eq 'cancelled'
    end
  end

  def add_rpush_app
    if Rpush::Apns::App.find_by_name("framework").nil?
      app = Rpush::Apns::App.new
      app.name = 'framework'
      app.certificate = File.read("#{Rails.root}/config/certs/fram-apns-dev.pem")
      app.environment = 'sandbox' # APNs environment.
      app.password = nil
      app.connections = 1
      app.save!
    end
  end
end

