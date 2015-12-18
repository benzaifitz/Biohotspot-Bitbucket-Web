class NotificationMailer < ApplicationMailer

  def notification_email(notification)
    sender = notification.sender
    recipient = notification.user
    @message = notification.message

    mail(from: sender.email, to: recipient.email, subject: notification.subject)
  end
end
