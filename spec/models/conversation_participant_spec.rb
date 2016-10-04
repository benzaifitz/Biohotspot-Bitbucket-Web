# == Schema Information
#
# Table name: conversations
#
#  id                :integer          not null, primary key
#  user_id           :integer          not null
#  conversation_id   :integer          not null
#


require 'rails_helper'

describe ConversationParticipant do

  describe '#conversation participant' do
    it 'has a valid factory' do
      expect(build(:conversation_participant)).to be_valid
    end

    it 'is invalid without a user_id' do
      expect(build(:conversation_participant, user_id: nil)).to_not be_valid
    end

    it 'is invalid without a conversation_id' do
      expect(build(:conversation_participant, conversation_id: nil)).to_not be_valid
    end
  end

  describe 'ActiveModel validations' do
    let(:conversation_participant) { build(:conversation_participant) }
    # Basic validations
    it { should validate_presence_of(:user_id).with_message(/can't be blank/) }
    it { should validate_presence_of(:conversation_id).with_message(/can't be blank/) }
    it { expect(create(:conversation_participant)).to validate_uniqueness_of(:user_id).scoped_to(:conversation_id) }
  end



  describe 'ActiveRecord associations' do
    let(:conversation_participant) { build(:conversation_participant) }
    it { should belong_to(:community_conversation) }
    it { should belong_to(:participant) }
  end
end