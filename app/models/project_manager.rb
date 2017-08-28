class ProjectManager < User
  default_scope -> { where(user_type: User.user_types['project_manager']) }
  scope :without_blocked_users, -> (blocked_by_id) { where("#{Project Manager.table_name}.id NOT IN(SELECT user_id FROM blocked_users where blocked_by_id = ?)", blocked_by_id) }
  # has_one :managed_project, class_name: 'Project', foreign_key: :project_manager_id
  belongs_to :managed_project, class_name: 'Project', foreign_key: :managed_project_id
  before_update :check_duplicate_email
  accepts_nested_attributes_for :managed_project

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