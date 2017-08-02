ActiveAdmin.register Project do

  permit_params do
    allowed = [:title, :summary, :tags, :client_name]
    allowed.uniq
  end

  actions :all

  index do
    selectable_column
    id_column
    column :title, label: "Project Title"
    column :summary, label: "Project Summary"
    column :tags
    column "Number_of_users" do |p|
      p.users.count
    end
    column :client_name
    #TODO needs to implement this column after establishing sites association.
    column :sites do |p|
      "--"
    end
    column :created_at
    column :updated_at
    actions
  end

end