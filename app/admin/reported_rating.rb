ActiveAdmin.register ReportedRating do

  actions :index

  index do
    column :created_at
    column :reported_by
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
      label r.rating.rated_on.name
    end
    column 'Rating For Company' do |r|
      label r.rating.rated_on.company
    end
    column 'Rating For User Type' do |r|
      label r.rating.rated_on.user_type
    end
    column 'Rating By' do |r|
      label r.rating.user.name
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
      (item 'Ban', ban_admin_reported_rating_path(r), class: 'member_link', method: :put) if r.rating.rated_on.active?
      (item 'Enable', enable_admin_reported_rating_path(r), class: 'member_link', method: :put) if r.rating.rated_on.banned?
      (item 'Censor', censor_admin_reported_rating_path(r), class: 'member_link', method: :put) if r.rating.active? || r.rating.allowed?
      (item 'Allow', allow_admin_reported_rating_path(r), class: 'member_link', method: :put) if !r.rating.allowed?
    end
  end


  member_action :ban, method: :put do
    resource.rating.rated_on.banned!
    redirect_to admin_reported_ratings_path, notice: 'User Banned!'
  end

  member_action :enable, method: :put do
    resource.rating.rated_on.active!
    redirect_to admin_reported_ratings_path, notice: 'User Enabled!'
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
