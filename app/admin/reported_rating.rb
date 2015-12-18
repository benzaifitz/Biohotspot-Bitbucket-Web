ActiveAdmin.register ReportedRating do
  include SharedAdmin

  menu label: 'Reported Comments', parent: 'User Content', priority: 2

  actions :index

  index do
    column :created_at
    column 'Reported By' do |r|
      link_to r.reported_by.username, admin_user_path(r.reported_by)
    end
    column 'Reported By Company' do |r|
      label r.reported_by.company
    end
    column 'Reported By User Type' do |r|
      label r.reported_by.user_type
    end
    column 'Rating' do |r|
      r.rating.rating
    end
    column 'Rating For' do |r|
      link_to r.rating.rated_on.username, admin_user_path(r.rating.rated_on)
    end
    column 'Rating For Company' do |r|
      label r.rating.rated_on.company
    end
    column 'Rating For User Type' do |r|
      label r.rating.rated_on.user_type
    end
    column 'Rating By' do |r|
      link_to r.rating.user.username, admin_user_path(r.rating.user)
    end
    column 'Rating By Company' do |r|
      label r.rating.user.company
    end
    column 'Rating By User Type' do |r|
      label r.rating.user.user_type
    end
    column "Rating By User's Rating" do |r|
      label r.rating.user.rating
    end
    column 'Comment' do  |r|
      label r.rating.comment
    end
    column 'Status' do |r|
      label r.rating.status
    end
    actions do |r|
      (item 'Ban', confirm_status_change_admin_reported_rating_path(r, status_change_action: 'ban'), class: 'fancybox member_link', data: { 'fancybox-type' => 'ajax' }) if r.bannable.active?
      (item 'Enable', confirm_status_change_admin_reported_rating_path(r, status_change_action: 'enable'), class: 'fancybox member_link', data: { 'fancybox-type' => 'ajax' }) if r.bannable.banned?
      (item 'Censor', censor_admin_reported_rating_path(r), class: 'member_link', method: :put) if r.rating.active? || r.rating.allowed?
      (item 'Allow', allow_admin_reported_rating_path(r), class: 'member_link', method: :put) if !r.rating.allowed?
    end
  end

  member_action :censor, method: :put do
    resource.rating.censored!
    redirect_to admin_reported_ratings_path, notice: 'Rating Censored!'
  end

  member_action :allow, method: :put do
    resource.rating.allowed!
    redirect_to admin_reported_ratings_path, notice: 'Rating Allowed!'
  end

  filter :reported_by
  filter :rating_rating, label: 'Rating', as: :select, collection: -> {Rating.distinct.pluck :rating}
  filter :created_at
end
