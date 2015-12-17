class MailchimpUpdateUserJob < ActiveJob::Base
  queue_as :mailchimp

  def perform(id, old_email)
    user = User.find(id)
    return if user.nil?
    begin
      # delete old record from mailchimp because we cannot update email
      if old_email != user.email
        delete_memeber(old_email)
        create_member(user)
      else
        member_data = get_member(old_email)
        member_data.nil? ? create_member(user) : update_member(user, old_email)
      end
    rescue => ex
      Rails.logger.error "[Mailchimp] - #{ex.message}"
    end
  end

  def create_member(user)
    list_id = Rails.application.secrets.mailchimp_list_id
    gb = Gibbon::Request.new(api_key: Rails.application.secrets.mailchimp_api_key)
    gb.lists(list_id).members
        .create(body: {email_address: user.email, status: 'subscribed',
                       merge_fields: {FNAME: user.first_name, LNAME: user.last_name,
                                      COMPANY: user.company, RATING: user.rating}})
  end

  def update_member(user, old_email)
    list_id = Rails.application.secrets.mailchimp_list_id
    member_id = Digest::MD5.hexdigest old_email
    gb = Gibbon::Request.new(api_key: Rails.application.secrets.mailchimp_api_key)
    gb.lists(list_id).members(member_id)
        .update(body: { merge_fields: {FNAME: user.first_name, LNAME: user.last_name,
                                       COMPANY: user.company, RATING: user.rating }})
  end

  def delete_memeber(old_email)
    list_id = Rails.application.secrets.mailchimp_list_id
    member_id = Digest::MD5.hexdigest old_email
    gb = Gibbon::Request.new(api_key: Rails.application.secrets.mailchimp_api_key)
    gb.lists(list_id).members(member_id).delete rescue nil
  end

  def get_member(old_email)
    list_id = Rails.application.secrets.mailchimp_list_id
    member_id = Digest::MD5.hexdigest old_email
    gb = Gibbon::Request.new(api_key: Rails.application.secrets.mailchimp_api_key)
    gb.lists(list_id).members(member_id).retrieve rescue nil
  end


end
