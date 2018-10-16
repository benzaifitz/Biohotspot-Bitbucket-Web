ActiveAdmin.register SpecieType, namespace: :pm do

  menu label: 'Species Types', priority: 6

  permit_params do
    allowed = [:id, :name]
    allowed.uniq
  end

  actions :all

  index do
    selectable_column
    id_column
    column :name
    column :created_at
    actions
  end
  show do
    attributes_table do
      row :id
      row :name
      row :created_at
      row :updated_at
    end
  end
  filter :name
  filter :created_at

end