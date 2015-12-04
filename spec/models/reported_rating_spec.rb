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

RSpec.describe ReportedRating, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
