ActiveAdmin.register Rating do

  actions :index

  index do
    column :created_at
    column :rating
    column 'Rating For' do |r|
      label r.rated_on.name
    end
    column 'Rating For Company' do |r|
      label r.rated_on.company
    end
    column 'Rating For User Type' do |r|
      label r.rated_on.user_type
    end
    column 'Rating By', :user
    column 'Rating By Company' do |r|
      label r.user.company
    end
    column 'Rating By User Type' do |r|
      label r.user.user_type
    end
    column :comment
    column :status
    actions do |r|
      (item 'Ban', ban_admin_rating_path(r.rated_on), class: 'member_link', method: :put) if r.rated_on.active?
      (item 'Enable', enable_admin_rating_path(r.rated_on), class: 'member_link', method: :put) if r.rated_on.banned?
      (item 'Censor', censor_admin_rating_path(r), class: 'member_link', method: :put) if r.active? || r.allowed?
      (item 'Allow', allow_admin_rating_path(r), class: 'member_link', method: :put) if r.censored?
    end
  end


  member_action :ban, method: :put do
    resource.rated_on.banned!
    redirect_to admin_ratings_path, notice: 'User Banned!'
  end

  member_action :enable, method: :put do
    resource.rated_on.active!
    redirect_to admin_ratings_path, notice: 'User Enabled!'
  end

  member_action :censor, method: :put do
    resource.censored!
    redirect_to admin_ratings_path, notice: 'Rating Censored!'
  end

  member_action :allow, method: :put do
    resource.allowed!
    redirect_to admin_ratings_path, notice: 'Rating Allowed!'
  end


end
