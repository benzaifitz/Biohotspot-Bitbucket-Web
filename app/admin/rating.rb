ActiveAdmin.register Rating do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end

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
  end


end
