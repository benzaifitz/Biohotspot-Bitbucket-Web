ActiveAdmin.register CategoryDocument, as: 'Document Category', namespace: :pm do

  menu label: 'Document Categories', parent: 'Documents', priority: 2

  permit_params do
     [:name]
  end

  actions :all
  show do
    attributes_table :id, :name, :updated_at, :created_at
  end


end
