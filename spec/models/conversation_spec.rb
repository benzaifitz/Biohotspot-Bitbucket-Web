# == Schema Information
#
# Table name: conversations
#
#  id           :integer          not null, primary key
#  name         :string
#  user_id      :integer
#  from_user_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  last_message :text
#  last_user_id :integer
#

require 'rails_helper'

describe Conversation do

  describe '#conversation' do
    it 'has a valid factory' do
      expect(build(:conversation)).to be_valid
    end

    it 'is invalid without a user_id for direct chat' do
      expect(build(:conversation, user_id: nil)).to_not be_valid
    end

    it 'is valid without a user_id for coummunity chat' do
      expect(build(:conversation, conversation_type: 1, user_id: nil)).to be_valid
    end

    it 'is invalid without a from_user_id' do
      expect(build(:conversation, from_user_id: nil)).to_not be_valid
    end
  end

  describe 'ActiveModel validations' do
    let(:conversation) { build(:conversation) }
    # Basic validations
    it { should validate_presence_of(:from_user_id).with_message(/can't be blank/) }

    context 'Conditional validations for direct chat' do
      let(:conversation) { build(:conversation, conversation_type: 0)}
      it { should validate_presence_of(:user_id).with_message(/can't be blank/) }
    end

    context 'Custom Validations for chat involving two users' do
      let(:conversation) { build(:conversation) }
      it 'cannot create a conversation involving same two users' do
        expect(conversation).to be_valid
        conversation.save!
        expect(build(:conversation, user_id: conversation.from_user_id, from_user_id: conversation.user_id)).to_not be_valid
      end
    end
  end



  describe 'ActiveRecord associations' do
    let(:conversation) { build(:conversation) }
    it { should have_many(:chats) }
    it { should have_many(:conversation_participants) }
    it { should belong_to(:recipient) }
    it { should belong_to(:from_user) }
  end

  describe 'Class methods' do
    it 'get all conversations of a user' do
      conversation = create(:conversation)
      create(:conversation, from_user_id: conversation.from_user_id, recipient: create(:user), conversation_type: 0)
      create(:conversation, from_user_id: conversation.from_user_id, conversation_type: 1, user_id: nil)
      create(:conversation_participant, user_id: conversation.from_user_id, conversation_id: conversation.id)
      expect(Conversation.get_all_chats_for_user(conversation.from_user_id).size).to eq 3
    end

    it 'should get a conversation between two users' do
      conversation = create(:conversation)
      expect(Conversation.users_direct_chat(conversation.from_user_id, conversation.user_id)).to eq conversation
    end
  end

  describe 'Instance methods' do
    it 'check if a user is a participant of a conversation' do
      conversation = create(:conversation)
      create(:conversation_participant, user_id: conversation.from_user_id, conversation_id: conversation.id)
      expect(conversation.has_participant?(conversation.from_user_id)).to eq true
      expect(conversation.has_participant?(conversation.from_user_id+10)).to eq false
    end

    it 'should add participants to a community conversation' do
      conversation = create(:conversation, conversation_type: 1)
      users = []
      3.times do
        users << create(:user)
      end
      users << conversation.from_user
      conversation.add_participants(users.map(&:id).join(','))
      expect(conversation.conversation_participants.count).to eq 4
      expect(conversation.conversation_participants.map(&:user_id).include?(conversation.from_user_id)).to eq true
    end

    it 'should not add participants to a direct conversation' do
      conversation = create(:conversation, conversation_type: 0)
      users = []
      3.times do
        users << create(:user)
      end
      users << conversation.from_user
      conversation.add_participants(users.map(&:id).join(','))
      expect(conversation.errors.full_messages[0]).to match /Cannot add participants to a private chat/
    end
  end

  describe 'dependent destroy for conversation' do
    it 'should delete chats of a conversation' do
      add_rpush_app
      conversation = create(:conversation)
      conversation.chats.create(attributes_for(:chat).merge(from_user: create(:user)))
      expect(conversation.chats.count).to eq 1
      conversation.destroy!
      expect(conversation.chats.count).to eq 0
    end

    it 'should delete conversation_participants of a conversation' do
      conversation = create(:conversation, conversation_type: Conversation.conversation_types[:community])
      conversation.conversation_participants.create(community_conversation: conversation, participant: create(:user))
      expect(conversation.conversation_participants.count).to eq 1
      conversation.destroy!
      expect(conversation.conversation_participants.count).to eq 0
    end
  end
end