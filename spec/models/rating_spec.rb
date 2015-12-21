# == Schema Information
#
# Table name: ratings
#
#  id          :integer          not null, primary key
#  rating      :decimal(, )
#  comment     :text
#  user_id     :integer
#  rated_on_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  status      :integer          default(0), not null
#

require 'rails_helper'

describe Rating do
  let(:statuses_order) { %w{active reported censored allowed} }

  describe '#rating' do
    it 'has a valid factory' do
      expect(build(:rating)).to be_valid
    end

    it 'is invalid without a rating' do
      expect(build(:rating, rating: nil)).to_not be_valid
    end

    it 'is invalid without a rated by user' do
      expect(build(:rating, user: nil)).to_not be_valid
    end

    it 'is invalid without a rated on user' do
      expect(build(:rating, rated_on: nil)).to_not be_valid
    end

    it 'is invalid without a status' do
      expect(build(:rating, status: nil)).to_not be_valid
    end

  end

  describe 'ActiveModel validations' do
    let(:rating) { build(:rating) }
    # Format validations
    it { expect(rating).to validate_inclusion_of(:rating).in_range(0..5) }
    it { should allow_value(0).for(:rating) }
    it { should allow_value(0.5).for(:rating) }
    it { should allow_value(2.5).for(:rating) }
    it { should_not allow_value(5.5).for(:rating) }
    # Basic validations
    it { should validate_presence_of(:rating).with_message(/can't be blank/) }
    it { should validate_presence_of(:user_id).with_message(/can't be blank/) }
    it { should validate_presence_of(:rated_on_id).with_message(/can't be blank/) }
    it { should validate_presence_of(:status).with_message(/can't be blank/) }
    it {expect(Rating.statuses.keys.length).to eq(statuses_order.length)}
  end

  describe '#status' do
    it 'has the right index' do
      statuses_order.each_with_index do |item, index|
        expect(described_class.statuses[item]).to eq index
      end
    end
  end


  describe 'ActiveRecord associations' do
    let(:rating) { build(:rating) }
    it { should belong_to(:user) }
    it { should belong_to(:rated_on) }
    it { should have_many(:reported_ratings) }
  end

  context 'callbacks' do
    let(:user) { create(:user) }
    it { should callback(:add_to_average_rating).before(:save) }
    it { should callback(:minus_from_average_rating).before(:save) }

  end

end

