ActiveAdmin.register CategoryDocument, as: 'Document Category' do

  menu label: 'Document Categories', parent: 'Document', priority: 2

  permit_params do
     [:name]
  end

  actions :all



end
