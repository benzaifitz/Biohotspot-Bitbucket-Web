class NotificationMailer < ApplicationMailer

  def notification_email(notification)
    sender = notification.sender
    recipient = notification.user
    @message = notification.alert

    mail(from: sender.email, to: recipient.email, subject: notification.category)
  end

  # provide to, from, subject and message in options
  # options = {to: 'to@test.com', from: 'from@test.com', subject: 'Hello World!', message: 'Viva la revolucion!'}
  # from can be skipped if you want to use the default from address for the mailer
  def send_email(options)
    @message = options[:message]

    mail(options)
  end
end
