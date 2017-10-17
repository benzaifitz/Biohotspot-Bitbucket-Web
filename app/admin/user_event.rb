ActiveAdmin.register PaperTrail::Version, as: 'User Events' do

  menu label: 'User Events', parent: 'Users', priority: 2

  actions :index

  index do
    id_column
    column :created_at
    column "User" do |v|
      link_to v.item.username, admin_user_path(v.item)
    end
    column :email do |v|
      label v.item.email
    end
    column :event, label: 'Event Type'
    column 'Admin' do |v|
      user = v.whodunnit.nil? ? nil : User.find(v.whodunnit)
      label user.nil? ? '' : link_to(user.username, admin_user_path(user))
    end
    column :comment
  end

  controller do
    def scoped_collection
      PaperTrail::Version.where(item_type: 'User').order('id asc').includes(:item)
    end
  end

  filter :event, as: :select, collection: -> { PaperTrail::Version.where(item_type: 'User').distinct.pluck :event }
  filter :item_id, label: 'Username', as: :select, collection: -> {
                   User.where(id: PaperTrail::Version.where(item_type: 'User').distinct.pluck(:item_id)).map do |u|
                     u.first_name.nil? ? [u.email, u.id] : ["#{u.first_name} #{u.last_name}", u.id]
                   end
                 }
  filter :created_at
  filter :whodunnit, label: "Performed By", as: :select, collection: -> { User.administrator }

end

