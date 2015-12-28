class NotificationMailer < ApplicationMailer

  def notification_email(notification)
    sender = notification.sender
    recipient = notification.user
    @message = notification.alert

    mail(from: sender.email, to: recipient.email, subject: notification.category)
  end
end
