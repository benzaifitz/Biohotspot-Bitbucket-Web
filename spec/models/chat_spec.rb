# == Schema Information
#
# Table name: chats
#
#  id              :integer          not null, primary key
#  message         :text
#  conversation_id :integer
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

    [:from_user_id, :conversation_id, :status].each do |prop|
      it "is invalid without a #{prop.to_s}" do
        expect(build(:chat, prop => nil)).to_not be_valid
      end
    end
  end

  describe 'ActiveModel validations' do
    let(:chat) { build(:chat) }
    # Basic validations
    [:from_user_id, :conversation_id, :status].each do |prop|
      it { should validate_presence_of(prop).with_message(/can't be blank/) }
    end
  end


  describe 'ActiveRecord associations' do
    let(:chat) { build(:chat) }
    it { should belong_to(:conversation) }
    it { should belong_to(:from_user) }
    it { should have_many(:reported_chats) }
  end

  describe 'instance methods' do

    it 'should mark the chat as read' do
      add_rpush_app
      chat = create(:chat)
      chat.mark_read
      expect(chat.is_read).to eq true
    end

    it 'should return sender' do
      add_rpush_app
      chat = create(:chat)
      expect(chat.sender).to eq chat.from_user
    end
  end

  describe 'dependent destroy for rating' do

    it 'should delete reported chats of a chat' do
      add_rpush_app
      chat = create(:chat)
      chat.reported_chats.create(reported_by: create(:user))
      expect(chat.reported_chats.count).to eq 1
      chat.destroy!
      expect(chat.reported_chats.count).to eq 0
    end
  end

end
