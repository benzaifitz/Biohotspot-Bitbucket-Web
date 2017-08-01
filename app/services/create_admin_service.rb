class CreateAdminService
  def call
    user = User.find_or_create_by!(email: Rails.application.secrets.admin_email) do |user|
        user.email = 'admin@pwm.com.au'
        user.username = 'admin'
        user.user_type = User.user_types[:administrator]
        user.password = Rails.application.secrets.admin_password
        user.password_confirmation = Rails.application.secrets.admin_password
        user.confirm
      end
  end
end
