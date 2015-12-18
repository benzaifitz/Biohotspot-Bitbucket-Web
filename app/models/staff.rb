class Staff < User
  paginates_per 20
  default_scope -> { where(user_type: User.user_types['staff']) }
  before_update :check_duplicate_email

  def self.search(search)
    if search
      where('first_name LIKE ? OR last_name LIKE ?', "%#{search}%", "%#{search}%")
    else
      all
    end
  end

  def check_duplicate_email
    if self.email != self.email_was && !User.find_by_email(self.email).nil?
      self.errors.add(:email, 'Duplicate email!') && false
    else
      true
    end
  end
end