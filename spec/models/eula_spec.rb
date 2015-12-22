# == Schema Information
#
# Table name: eulas
#
#  id         :integer          not null, primary key
#  eula_text  :text
#  is_latest  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe Eula do
  describe '#eula' do
    it 'has a valid factory' do
      expect(build(:eula)).to be_valid
    end
  end

  describe 'callbacks calculate value correctly' do
    it '.old records is_latest is set to false' do
      eula_1 = create(:eula, is_latest: true)
      eula_2 = create(:eula, is_latest: true)
      eula_3 = create(:eula, is_latest: true)
      eula_1.reload
      eula_2.reload
      eula_3.reload
      expect(eula_1.is_latest).to eq(false)
      expect(eula_2.is_latest).to eq(false)
      expect(eula_3.is_latest).to eq(true)
    end

  end

end
