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

    it 'is invalid without a user_id' do
      expect(build(:conversation, user_id: nil)).to_not be_valid
    end

    it 'is invalid without a from_user_id' do
      expect(build(:conversation, from_user_id: nil)).to_not be_valid
    end
  end

  describe 'ActiveModel validations' do
    let(:conversation) { build(:conversation) }
    # Basic validations
    it { should validate_presence_of(:user_id).with_message(/can't be blank/) }
    it { should validate_presence_of(:from_user_id).with_message(/can't be blank/) }

    context 'Custom Validations for chat involving two users' do
      let(:conversation) { build(:conversation) }
      it 'cannot create a converstion involving same two users' do
        expect(conversation).to be_valid
        conversation.save!
        expect(build(:conversation, user_id: conversation.from_user_id, from_user_id: conversation.user_id)).to_not be_valid
      end
    end
  end



  describe 'ActiveRecord associations' do
    let(:conversation) { build(:conversation) }
    it { should have_many(:chats) }
    it { should belong_to(:user) }
    it { should belong_to(:from_user) }
  end
end