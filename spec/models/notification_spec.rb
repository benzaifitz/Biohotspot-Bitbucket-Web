# == Schema Information
#
# Table name: notifications
#
#  id                :integer          not null, primary key
#  subject           :string
#  message           :text
#  user_id           :integer
#  sent_by_id        :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  notification_type :integer          default(0), not null
#  user_type         :integer          default(0), not null
#

require 'rails_helper'

RSpec.describe Notification, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
