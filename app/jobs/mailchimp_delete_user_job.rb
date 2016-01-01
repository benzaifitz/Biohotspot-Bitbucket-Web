class MailchimpDeleteUserJob < ActiveJob::Base
  queue_as :mailchimp

  def perform(email)
    list_id = Rails.application.secrets.mailchimp_list_id
    member_id = Digest::MD5.hexdigest email
    gb = Gibbon::Request.new(api_key: Rails.application.secrets.mailchimp_api_key)
    begin
      gb.lists(list_id).members(member_id).delete rescue nil
    rescue => ex
      Rails.logger.error "[Mailchimp] - #{ex.message}"
    end
  end
end
