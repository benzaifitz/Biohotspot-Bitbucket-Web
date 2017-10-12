ActiveAdmin.register CategoryDocument, as: 'Document Category' do

  menu label: 'Document Categories', priority: 14

  permit_params do
     [:name]
  end

  actions :all



end
