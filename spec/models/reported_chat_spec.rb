# == Schema Information
#
# Table name: reported_chats
#
#  id             :integer          not null, primary key
#  chat_id        :integer
#  reported_by_id :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

RSpec.describe ReportedChat, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
