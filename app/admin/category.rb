ActiveAdmin.register Category do

  menu label: 'Categories List', parent: 'Categories', priority: 1

  permit_params do
    allowed = [:name, :description, :tags, :class_name, :family, :location, :url, :site_id]
    allowed.uniq
  end

  actions :all

  # index do
  #   selectable_column
  #   id_column
  #   column :title, label: "Project Title"
  #   column :summary, label: "Project Summary"
  #   column :tags
  #   column "Number_of_users" do |p|
  #     p.users.count
  #   end
  #   column :client_name
  #   #TODO needs to implement this column after establishing sites association.
  #   column :sites do |p|
  #     "--"
  #   end
  #   column :created_at
  #   column :updated_at
  #   actions
  # end

end