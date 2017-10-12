ActiveAdmin.register CategoryDocument, as: 'Document Category' do

  menu label: 'Document Categories', priority: 10

  permit_params do
     [:name]
  end

  actions :all



end
