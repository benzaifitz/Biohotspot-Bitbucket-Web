# == Schema Information
#
# Table name: privacies
#
#  id           :integer          not null, primary key
#  privacy_text :text
#  is_latest    :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

describe Privacy do
  describe '#privacy' do
    it 'has a valid factory' do
      expect(build(:privacy)).to be_valid
    end
  end

  describe 'callbacks calculate value correctly' do
    it '.old records is_latest is set to false' do
      privacy_1 = create(:privacy, is_latest: true)
      privacy_2 = create(:privacy, is_latest: true)
      privacy_3 = create(:privacy, is_latest: true)
      privacy_1.reload
      privacy_2.reload
      privacy_3.reload
      expect(privacy_1.is_latest).to eq(false)
      expect(privacy_2.is_latest).to eq(false)
      expect(privacy_3.is_latest).to eq(true)
    end

  end

end
