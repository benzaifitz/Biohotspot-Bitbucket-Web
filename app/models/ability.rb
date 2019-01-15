class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    if user.administrator? 
      can :manage, :all
    elsif user.project_manager?
      can [:read, :update, :change_project_status, :invite], Project, id: user.projects.pluck(:id)
      can :create, Project
      can [:read, :update], Location, id: user.locations.pluck(:id)
      can :create, Location
      can [:read, :update], Site, id: user.sites.pluck(:id)
      can :create, Site
      can [:read, :update], SubCategory, id: user.sub_categories.pluck(:id)
      can :create, SubCategory
      can [:create, :read, :update], Category
      can [:read, :create, :update], SpecieType
      can [:read, :update, :approve, :reject_submission, :reject], Submission, id: user.managed_submissions.pluck(:id)
      can :create, Submission
      can [:read, :update, :approve, :reject_image, :reject], Photo, imageable_id: user.managed_submissions.pluck(:id), imageable_type: "Submission"
      can :read, ProjectManagerProject, id: ProjectManagerProject.where(project_id: user.projects.pluck(:id))
      can [:read, :accept, :reject], ProjectRequest, id: ProjectRequest.where(project_id: user.projects.pluck(:id))
      can :manage, ActiveAdmin::Page, name: 'Maps'

      can :read, Rpush::Client::ActiveRecord::Notification, user_id: land_managers_plus_project_managers(user)
      can :create, Rpush::Client::ActiveRecord::Notification
      can :manage, Feedback, project_id: user.projects.map(&:id)
      
      
      can [:read, :update, :destroy], CategoryDocument, id: (user.projects.map(&:documents).flatten.map(&:category_document) rescue 0)
      can :create, CategoryDocument
      can :read, BlockedUser, id: land_managers_plus_project_managers(user)
      
      can :manage, User, id: land_managers_plus_project_managers(user)
      can :create, User
      can :manage, PaperTrail::Version, item_id: land_managers_plus_project_managers(user), item_type: 'User'
      # can :read, Rpush::Client::ActiveRecord::Notification, user_id: LandManager.joins(locations:[:project]).where("projects.id in (?)", user.managed_projects.pluck(:id)).pluck(:id)
      can [:read, :update, :destroy], Document, id:  user.projects.map(&:document_ids).flatten
      can :create, Document
    end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end

  def land_managers_plus_project_managers(user)
    (user.land_managers.pluck(:id) + ProjectManagerProject.where(project_id: user.projects.pluck(:id)).map(&:project_manager_id)).uniq
  end  
end
