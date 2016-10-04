ActiveAdmin.register Rating do

  include SharedAdmin

  menu label: 'Ratings and Comments', parent: 'User Content', priority: 1

  actions :index

  filter :rating
  filter :comment
  filter :rated_on_username_cont, label: 'Rating For(Username)'
  filter :rated_on_first_name_cont, label: 'Rating For(First Name)'
  filter :rated_on_last_name_cont, label: 'Rating For(Last Name)'
  filter :user_username_cont, label: 'Rating By(Username)'
  filter :user_first_name_cont, label: 'Rating By(Username)'
  filter :user_last_name_cont, label: 'Rating By(Username)'
  filter :status, as: :select, collection: -> { Rating.statuses }
  filter :created_at

  index do
    column :created_at
    column :rating
    column 'Rating For' do |r|
      link_to r.rated_on.username, admin_user_path(r.rated_on)
    end
    column 'Rating For Company' do |r|
      label r.rated_on.company
    end
    column 'Rating For User Type' do |r|
      label r.rated_on.user_type
    end
    column 'Rating By' do |r|
      link_to r.user.username, admin_user_path(r.user)
    end
    column 'Rating By Company' do |r|
      label r.user.company
    end
    column 'Rating By User Type' do |r|
      label r.user.user_type
    end
    column :comment
    column :status
    actions do |r|
      (item 'Ban', confirm_status_change_admin_rating_path(r, status_change_action: 'ban'), class: 'fancybox member_link', data: { 'fancybox-type' => 'ajax' }) if r.bannable.active?
      (item 'Enable', confirm_status_change_admin_rating_path(r, status_change_action: 'enable'), class: 'fancybox member_link', data: { 'fancybox-type' => 'ajax' }) if r.bannable.banned?
      (item 'Censor', censor_admin_rating_path(r), class: 'member_link', method: :put) if r.active? || r.allowed?
      (item 'Allow', allow_admin_rating_path(r), class: 'member_link', method: :put) if !r.allowed?
    end
  end

  member_action :censor, method: :put do
    resource.censored!
    redirect_to admin_ratings_path, notice: 'Rating Censored!'
  end

  member_action :allow, method: :put do
    resource.allowed!
    redirect_to admin_ratings_path, notice: 'Rating Allowed!'
  end

  controller do
    def scoped_collection
      super.includes(:rated_on, :user)
    end
  end
end
