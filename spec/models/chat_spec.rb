# == Schema Information
#
# Table name: chats
#
#  id              :integer          not null, primary key
#  message         :text
#  conversation_id :integer
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  status          :integer          default(0), not null
#  from_user_id    :integer

require 'rails_helper'

describe Chat do

  describe '#chat' do
    it 'has a valid factory' do
      expect(build(:chat)).to be_valid
    end

    [:user_id, :from_user_id, :conversation_id, :status].each do |prop|
      it "is invalid without a #{prop.to_s}" do
        expect(build(:chat, prop => nil)).to_not be_valid
      end
    end
  end

  describe 'ActiveModel validations' do
    let(:chat) { build(:chat) }
    # Basic validations
    [:user_id, :from_user_id, :conversation_id, :status].each do |prop|
      it { should validate_presence_of(prop).with_message(/can't be blank/) }
    end
  end


  describe 'ActiveRecord associations' do
    let(:chat) { build(:chat) }
    it { should belong_to(:conversation) }
    it { should belong_to(:user) }
    it { should belong_to(:from_user) }
    it { should have_many(:reported_chats) }
  end

  describe 'instance methods' do
    it 'should mark the chat as read' do
      chat = create(:chat)
      chat.mark_read
      expect(chat.is_read).to eq true
    end

    it 'should return sender' do
      chat = create(:chat)
      expect(chat.sender).to eq chat.from_user
    end

    it 'should return recipient' do
      chat = create(:chat)
      expect(chat.recipient).to eq chat.user
    end
  end


end
