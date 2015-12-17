class MailchimpUpdateUserJob < ActiveJob::Base
  queue_as :mailchimp

  def perform(id, old_email)
    user = User.find(id)
    return if user.nil?
    list_id = Rails.application.secrets.mailchimp_list_id
    member_id = Digest::MD5.hexdigest old_email
    gb = Gibbon::Request.new(api_key: Rails.application.secrets.mailchimp_api_key)
    # delete old record from mailchimp because we cannot update email
    begin
      if old_email != user.email
        gb.lists(list_id).members(member_id).delete rescue nil
        gb.lists(list_id).members
            .create(body: {email_address: user.email, status: 'subscribed',
                           merge_fields: {FNAME: user.first_name, LNAME: user.last_name,
                                          COMPANY: user.company, RATING: user.rating}})
      else
        gb.lists(list_id).members(member_id)
            .update(body: { merge_fields: {FNAME: user.first_name, LNAME: user.last_name,
                                          COMPANY: user.company, RATING: user.rating }})
      end
    rescue Gibbon::MailChimpError => e
      Rails.logger.error "[Mailchimp] - #{e.message}"
    rescue => ex
      Rails.logger.error "[Mailchimp] - #{ex.message}"
    end
  end
end
