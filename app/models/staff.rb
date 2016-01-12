class Staff < User
  default_scope -> { where(user_type: User.user_types['staff']) }
  scope :without_blocked_users, -> (blocked_by_id) { where("#{Staff.table_name}.id NOT IN(SELECT user_id FROM blocked_users where blocked_by_id = ?)", blocked_by_id) }

  before_update :check_duplicate_email

  def self.search(options = {})
    if options.present?
      conditions = {}
      conditions = ["first_name ILIKE ? OR last_name ILIKE ?", "%#{options[:first_name]}%", "%#{options[:first_name]}%"] if options[:first_name].present?

      if options[:last_name].present?
        conditions[0] = "#{conditions[0]} OR last_name ILIKE ? OR first_name ILIKE ?  "
        conditions << "%#{options[:last_name]}%"
        conditions << "%#{options[:last_name]}%"
      end
      where(conditions)
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