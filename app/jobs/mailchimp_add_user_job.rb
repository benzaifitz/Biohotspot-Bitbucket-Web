class MailchimpAddUserJob < ApplicationJob
  queue_as :mailchimp

  def perform(id)
    user = User.find(id)
    return if user.nil?
    begin
      gb = Gibbon::Request.new(api_key: Rails.application.secrets.mailchimp_api_key)
      gb.lists(Rails.application.secrets.mailchimp_list_id).members
          .create(body: {email_address: user.email, status: 'subscribed',
                         merge_fields: {FNAME: user.first_name, LNAME: user.last_name,
                         COMPANY: user.company, RATING: user.rating}})
    rescue => ex
      Rails.logger.error "[Mailchimp] - #{ex.message}"
    end
  end
end
