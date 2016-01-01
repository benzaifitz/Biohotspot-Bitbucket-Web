# == Schema Information
#
# Table name: reported_ratings
#
#  id             :integer          not null, primary key
#  rating_id      :integer
#  reported_by_id :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

describe ReportedRating do

  describe '#reported rating' do
    it 'has a valid factory' do
      expect(build(:reported_rating)).to be_valid
    end

    it 'is invalid without a rating' do
      expect(build(:reported_rating, rating_id: nil)).to_not be_valid
    end

    it 'is invalid without a rated by user' do
      expect(build(:reported_rating, reported_by_id: nil)).to_not be_valid
    end
  end

  describe 'ActiveModel validations' do
    let(:reported_rating) { build(:reported_rating) }
    # Basic validations
    it { expect(create(:reported_rating)).to validate_uniqueness_of(:rating_id).scoped_to(:reported_by_id) }
    it { should validate_presence_of(:rating_id).with_message(/can't be blank/) }
    it { should validate_presence_of(:reported_by_id).with_message(/can't be blank/) }
  end

  describe 'ActiveRecord associations' do
    let(:reported_rating) { build(:reported_rating) }
    it { should belong_to(:rating) }
    it { should belong_to(:reported_by) }
  end

  context 'callbacks' do
    let(:reported_rating) { create(:reported_rating) }
    it { should callback(:update_rating_status_to_reported).after(:create) }
  end

end


