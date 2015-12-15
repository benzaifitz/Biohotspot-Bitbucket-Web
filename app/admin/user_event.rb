ActiveAdmin.register PaperTrail::Version, as: 'User Events' do

  actions :index

  index do
    id_column
    column :created_at
    column :first_name do |v|
      label v.reify.first_name
    end
    column :last_name do |v|
      label v.reify.last_name
    end
    column :email do |v|
      label v.reify.email
    end
    column :event
    column 'Admin' do |v|
      user = v.whodunnit.nil? ? nil : User.find(v.whodunnit)
      label user.nil? ? '' : (user.full_name.nil? ? user.email : user.full_name)
    end
    column :comment
  end

  controller do
    def scoped_collection
      PaperTrail::Version.where(item_type: 'User').order('id asc')
    end
  end

  filter :event, as: :select, collection: -> { PaperTrail::Version.where(item_type: 'User').distinct.pluck :event }
  filter :item_id, label: 'User Name', as: :select, collection: -> {
                   User.where(id: PaperTrail::Version.where(item_type: 'User').distinct.pluck(:item_id)).map do |u|
                     u.first_name.nil? ? [u.email, u.id] : ["#{u.first_name} #{u.last_name}", u.id]
                   end
                 }
  filter :created_at
  filter :whodunnit, label: "Performed By", as: :select, collection: -> { User.administrator }

end

