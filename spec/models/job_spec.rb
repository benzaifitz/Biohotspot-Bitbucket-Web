# == Schema Information
#
# Table name: jobs
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  offered_by_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  status        :integer          default(0)
#

require 'rails_helper'

RSpec.describe Job, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
