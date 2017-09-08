ActiveAdmin.register Document do

  menu label: 'Document List', parent: 'Document', priority: 1

  permit_params do
    [:name, :document,:project_id, :category_document_id]
  end

  index do
    selectable_column
    column :id
    column "Document" do |a|
      link_to "#{request.protocol}#{request.host_with_port}#{a.document.url}", "#{request.protocol}#{request.host_with_port}#{a.document.url}" if a.document.url.present?
    end
    column :name
    column :category_document_id
    column :project_id
    column :created_at
    column :updated_at
    actions do |a|
    end
  end

  show do
    attributes_table do
      row :id
      row :document do |a|
        link_to "#{request.protocol}#{request.host_with_port}#{a.document.u}", "#{request.protocol}#{request.host_with_port}#{a.document.url}" if a.document.url.present?
      end
      row :category_document_id
      row :project_id
      row :created_at
      row :updated_at
    end
  end
end
