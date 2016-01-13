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
describe User do
  let(:user_types_order) { %w{staff administrator customer} }
  let(:statuses_order) { %w{active banned} }
  let(:device_types_order) { %w{ios android} }

  describe '#staff' do
    it 'has a valid factory' do
      expect(build(:staff)).to be_valid
    end

    it 'is invalid without a email' do
      expect(build(:staff, email: nil)).to_not be_valid
    end

    it 'is invalid without a username' do
      expect(build(:staff, username: nil)).to_not be_valid
    end

    it 'is invalid without a company' do
      expect(build(:staff, company: nil)).to_not be_valid
    end
  end

  describe '#customer' do
    it 'has a valid factory' do
      expect(build(:customer)).to be_valid
    end

    it 'is invalid without a email' do
      expect(build(:customer, email: nil)).to_not be_valid
    end

    it 'is invalid without a username' do
      expect(build(:customer, username: nil)).to_not be_valid
    end

    it 'is valid without a company' do
      expect(build(:customer, company: nil)).to be_valid
    end
  end

  describe '#administrator' do
    it 'has a valid factory' do
      expect(build(:admin)).to be_valid
    end

    it 'is invalid without a email' do
      expect(build(:admin, email: nil)).to_not be_valid
    end

    it 'is invalid without a username' do
      expect(build(:admin, username: nil)).to_not be_valid
    end

    it 'is valid without a company' do
      expect(build(:admin, company: nil)).to be_valid
    end
  end

  describe 'ActiveModel validations' do
    let(:user) { build(:user) }
    # Format validations
    it { should allow_value("zahid@dapperapps.com.au").for(:email) }
    it { should_not allow_value("base@dapperapps").for(:email) }
    it { should_not allow_value("blah").for(:email) }
    it { should allow_value("zahidali").for(:username) }
    it { should_not allow_value("zahid ali").for(:username) }

    # Basic validations
    it { should validate_presence_of(:email).with_message(/can't be blank/) }
    it { should validate_presence_of(:username).with_message(/can't be blank/) }
    it { should validate_uniqueness_of(:username) }
    it {expect(User.user_types.keys.length).to eq(user_types_order.length)}
    it {expect(User.device_types.keys.length).to eq(device_types_order.length)}
    it {expect(User.statuses.keys.length).to eq(statuses_order.length)}
  end

  describe '#user type' do
    it 'has the right index' do
      user_types_order.each_with_index do |item, index|
        expect(described_class.user_types[item]).to eq index
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

  describe '#device types' do
    it 'has the right index' do
      device_types_order.each_with_index do |item, index|
        expect(described_class.device_types[item]).to eq index
      end
    end
  end

  describe 'ActiveRecord associations' do
    let(:user) { build(:user) }
    it { should belong_to(:eula) }
    it { should have_many(:ratings) }
    it { should have_many(:blocked_users) }
    it { should have_many(:jobs) }
    it { should have_many(:notifications) }
    it { should have_many(:user_conversations) }
    it { should have_many(:chats) }
  end

  context 'callbacks' do
    let(:user) { create(:user) }

    it { should callback(:add_to_mailchimp).after(:create) }
    it { should callback(:log_user_events).after(:update) }
    it { should callback(:update_on_mailchimp).after(:update) }
    it { should callback(:delete_from_mailchimp).after(:destroy) }
  end

end
