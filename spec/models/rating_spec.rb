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

  describe 'Custom validations' do
    it "should not allow two ratings to be added by customer for a staff within 24hrs" do
      rating = create(:rating, attributes_for(:rating).merge(user: create(:customer), rated_on: create(:staff)))
      expect(rating).to be_valid
      rating_2 = Rating.create(attributes_for(:rating).merge(user_id: rating.user_id, rated_on_id: rating.rated_on_id))
      expect(rating_2).to_not be_valid
      expect(rating_2.errors.full_messages[0]).to match /does not allow more than 1 comment in 24 hours./
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
    let(:rating) { build(:rating) }
    it { should belong_to(:user) }
    it { should belong_to(:rated_on) }
    it { should have_many(:reported_ratings) }
  end

  context 'callbacks' do
    let(:rating) { create(:rating) }
    it { should callback(:add_to_average_rating).before(:save) }
    it { should callback(:minus_from_average_rating).before(:save) }
  end

  describe 'callbacks calculate value correctly' do
    it '.calculated avg rating for rated on person correctly' do
      rated_on = create(:customer)
      rated_by_1 = create(:staff)
      rated_by_2 = create(:staff)
      create(:rating, rated_on: rated_on, user: rated_by_1, rating: 5)
      create(:rating, rated_on: rated_on, user: rated_by_2, rating: 3)
      rated_on.reload
      expect(rated_on.rating).to eq(4.0)
    end

    it '.recalculated avg rating for rated on person correctly after rating status is changed to censored' do
      rated_on = create(:customer)
      rated_by_1 = create(:staff)
      rated_by_2 = create(:staff)
      create(:rating, rated_on: rated_on, user: rated_by_1, rating: 5)
      rating_2 = create(:rating, rated_on: rated_on, user: rated_by_2, rating: 3)
      rating_2.update({status: 2})
      rated_on.reload
      expect(rated_on.rating).to eq(5.0)
    end

  end

  describe 'dependent destroy for rating' do
    it 'should delete chats of a conversation' do
      rating = create(:rating)
      rating.reported_ratings.create(reported_by: create(:user))
      expect(rating.reported_ratings.count).to eq 1
      rating.destroy!
      expect(rating.reported_ratings.count).to eq 0
    end
  end
end

