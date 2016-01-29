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
#  privacy_id             :integer
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
    it { should have_many(:blocked_by_blocked_users) }
    it { should have_many(:jobs) }
    it { should have_many(:offered_by_jobs) }
    it { should have_many(:rpush_notifications) }
    it { should have_many(:user_conversations) }
    it { should have_many(:community_conversations) }
    it { should have_many(:conversation_participants) }
    it { should have_many(:recipient_conversations) }
    it { should have_many(:chats) }
  end

  context 'callbacks' do
    let(:user) { create(:user) }

    it { should callback(:add_to_mailchimp).after(:commit).on(:create) }
    it { should callback(:log_user_events).after(:update) }
    it { should callback(:update_on_mailchimp).after(:save).if('mailchimp_related_fields_updated? && (created_at != updated_at)') }
    it { should callback(:delete_from_mailchimp).after(:commit).on(:destroy) }
  end

  context 'dependent destroy for staff' do
    let(:staff) {create(:user, user_type: User.user_types[:staff])}
    it 'should delete rated_on_ratings for this staff' do
      staff.rated_on_ratings.create(attributes_for(:rating).merge(comment: 'Test', user_id: create(:user, user_type: User.user_types[:customer]).id))
      expect(Rating.count).to eq 1
      staff.destroy!
      expect(Rating.count).to eq 0
    end

    it 'should delete blocked_users records of this staff' do
      staff.blocked_users.create(attributes_for(:blocked_user).merge(blocked_by_id: create(:user, user_type: User.user_types[:customer]).id))
      expect(BlockedUser.count).to eq 1
      staff.destroy!
      expect(BlockedUser.count).to eq 0
    end

    it 'should delete blocked_users records blocked by this staff' do
      staff.blocked_by_blocked_users.create(attributes_for(:blocked_user).merge(user_id: create(:user, user_type: User.user_types[:customer]).id))
      expect(BlockedUser.count).to eq 1
      staff.destroy!
      expect(BlockedUser.count).to eq 0
    end

    it 'should delete jobs offered to this staff' do
      staff.jobs.create(attributes_for(:job).merge(offered_by_id: create(:user, user_type: User.user_types[:customer]).id))
      expect(Job.count).to eq 1
      staff.destroy!
      expect(Job.count).to eq 0
    end

    it 'should delete coversation that this staff is recipient of and chat messages sent by this staff(direct chat)' do
      staff.recipient_conversations.create!(attributes_for(:conversation).merge(conversation_type: Conversation.conversation_types[:direct], from_user_id: create(:user, user_type: User.user_types[:customer]).id))
      staff.chats.create!(attributes_for(:chat).merge(conversation_id: staff.recipient_conversations.first.id))
      expect(staff.recipient_conversations.count).to eq 1
      expect(staff.chats.count).to eq 1
      staff.destroy!
      expect(Conversation.count).to eq 0
      expect(Chat.count).to eq 0
    end

    it 'should delete coversation participations and chat messages of this staff staff(community chat)' do
      conversation = create(:conversation, attributes_for(:conversation).merge(conversation_type: Conversation.conversation_types[:community], from_user_id: create(:user, user_type: User.user_types[:customer]).id))
      staff.conversation_participants.create(conversation_id: conversation.id)
      staff.chats.create(message: 'test', conversation_id: conversation.id)
      expect(staff.conversation_participants.count).to eq 1
      expect(staff.chats.count).to eq 1
      staff.destroy!
      expect(Chat.count).to eq 0
      expect(ConversationParticipant.count).to eq 0
      expect(Conversation.count).to eq 1 # Donot delete community conversation with user
    end

  end



  context 'dependent destroy for customer' do
    let(:customer) {create(:user, user_type: User.user_types[:customer])}
    it 'should delete ratings for this customer' do
      customer.ratings.create!(attributes_for(:rating).merge(comment: 'Test', rated_on_id: create(:user, user_type: User.user_types[:staff]).id))
      expect(Rating.count).to eq 1
      customer.destroy!
      expect(Rating.count).to eq 0
    end

    it 'should delete blocked_users records of this customer' do
      customer.blocked_users.create!(attributes_for(:blocked_user).merge(blocked_by_id: create(:user, user_type: User.user_types[:staff]).id))
      expect(BlockedUser.count).to eq 1
      customer.destroy!
      expect(BlockedUser.count).to eq 0
    end

    it 'should delete blocked_users records blocked by this customer' do
      customer.blocked_by_blocked_users.create!(attributes_for(:blocked_user).merge(user_id: create(:user, user_type: User.user_types[:staff]).id))
      expect(BlockedUser.count).to eq 1
      customer.destroy!
      expect(BlockedUser.count).to eq 0
    end

    it 'should delete jobs offered by this customer' do
      customer.offered_by_jobs.create!(attributes_for(:job).merge(user_id: create(:user, user_type: User.user_types[:staff]).id))
      expect(Job.count).to eq 1
      customer.destroy!
      expect(Job.count).to eq 0
    end

    it 'should delete coversation that this customer is from_user of and chat messages of this conv(direct chat)' do
      customer.user_conversations.create!(attributes_for(:conversation).merge(conversation_type: Conversation.conversation_types[:direct], user_id: create(:user, user_type: User.user_types[:staff]).id))
      customer.chats.create!(attributes_for(:chat).merge(conversation_id: customer.user_conversations.first.id))
      expect(customer.user_conversations.count).to eq 1
      expect(customer.chats.count).to eq 1
      customer.destroy!
      expect(Conversation.count).to eq 0
      expect(Chat.count).to eq 0
    end

    it 'should delete conversation, coversation participations and chat messages of this customer(community chat)' do
      conversation = create(:conversation, attributes_for(:conversation).merge(conversation_type: Conversation.conversation_types[:community], from_user_id: customer.id))
      customer.conversation_participants.create!(conversation_id: conversation.id)
      customer.chats.create!(message: 'test', conversation_id: conversation.id)
      expect(customer.conversation_participants.count).to eq 1
      expect(customer.chats.count).to eq 1
      expect(customer.user_conversations.count).to eq 1
      customer.destroy!
      expect(Chat.count).to eq 0
      expect(ConversationParticipant.count).to eq 0
      expect(Conversation.count).to eq 0
    end

  end

end
