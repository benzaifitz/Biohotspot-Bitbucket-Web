ActiveAdmin.register CategoryDocument do

  menu label: 'Categories Document List', parent: 'Categories Document', priority: 1

  permit_params do
     [:name]
  end

  actions :all



end
