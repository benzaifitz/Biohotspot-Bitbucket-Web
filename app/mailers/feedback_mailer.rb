class FeedbackMailer < ApplicationMailer

  def notification_email(notification)
    sender = notification.sender
    recipient = notification.user
    @message = notification.alert
    mail(to: recipient.email, subject: notification.category)
  end

  def email_project_manager(feedback_id)
    @feedback = Feedback.find(feedback_id)
    to_email = @feedback.project.project_manager.email rescue nil
    if to_email
      @project_title = @feedback.project.title rescue 'N/A'
      mail(to: to_email, subject: "Feeback received for #{@project_title}")
    end
  end

  def email_admin(feedback_id)
    @feedback = Feedback.find(feedback_id)
    admin_emails = User.administrators.map(&:email).compact.uniq.join(',')
    if admin_emails
      @project_title = @feedback.project.title rescue 'N/A'
      mail(to: admin_emails, subject: "Feeback received for #{@project_title}")
    end
  end

  def email_project
    @feedback = Feedback.first
    # to_email = @feedback.project.project_manager.email rescue nil
    # if to_email
      mail(to: 'zahid@dapperapps.com.au', subject: "Feeback recevied for ")
    # end
  end

end
