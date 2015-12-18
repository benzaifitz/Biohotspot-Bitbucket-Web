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
#  status            :integer          default(0), not null
#

class Notification < ActiveRecord::Base
  #belongs_to :user_type
  belongs_to :user
  #belongs_to :notification_type
  belongs_to :sender, class_name: "User", foreign_key: "sent_by_id"

  enum notification_type: [ :push, :email ]
  enum status: [ :created, :sent, :failed ]

  after_commit :enqueue_message_for_sending, on: :create

  class << self

    def enqueue_email_and_mark_it_sent(notification)
      begin
        NotificationMailer.notification_email(notification).deliver_now
        notification.sent!
      rescue StandardError => e
        notification.failed!
      end
    end
  end

  private

  def enqueue_message_for_sending
    if self.email?
      Notification.delay.enqueue_email_and_mark_it_sent(self)
    elsif self.push?
      # Add push notification
    end
  end
end
