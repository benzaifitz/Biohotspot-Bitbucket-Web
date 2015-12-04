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

class Notification < ActiveRecord::Base
  #belongs_to :user_type
  belongs_to :user
  #belongs_to :notification_type
  belongs_to :sender, class_name: "User", foreign_key: "sent_by_id"
end
