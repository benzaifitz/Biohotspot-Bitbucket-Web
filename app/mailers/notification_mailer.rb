class NotificationMailer < ApplicationMailer

  def notification_email(notification)
    sender = notification.sender
    recipient = notification.user
    @message = notification.alert
    mail(to: recipient.email, subject: notification.category)
  end

  def notify_admin_for_account_approval(account_id)
    @user = User.find(account_id) rescue nil
    if @user
      pm_emails = ProjectManager.all.map(&:email)
      mail(to: pm_emails.join(','), subject: 'Biohotspot: Approve new user.')
    end
  end

  # provide to, from, subject and message in options
  # options = {to: 'to@test.com', from: 'from@test.com', subject: 'Hello World!', message: 'Viva la revolucion!'}
  # from can be skipped if you want to use the default from address for the mailer
  def send_email(options)
    @message = options[:message]
    mail(options)
  end

  def invite_user(object=nil)
    return if object.nil?
    @project_manager_project = object
    #logic to encrypt token is above
    token = Base64.urlsafe_encode64([object.token, object.project_id, object.project_manager_id].join("_"))
    @token = token
    mail(to: object.project_manager.email, subject: "You’ve Been Invited To Join Project as Project Manager!")
  end

end
