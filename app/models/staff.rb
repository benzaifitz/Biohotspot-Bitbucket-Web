class Staff < User
  default_scope -> { where(user_type: User.user_types['staff']) }
  before_update :check_duplicate_email

  def check_duplicate_email
    if self.email != self.email_was && !User.find_by_email(self.email).nil?
      self.errors.add(:email, 'Duplicate email!') && false
    else
      true
    end
  end
end