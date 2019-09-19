ActiveAdmin.register Document do

  menu label: 'Document List', parent: 'Documents', priority: 1

  permit_params do
    [:name, :document, :category_document_id, project_ids: []]
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Document Details' do
      f.input :name
      f.input :document, as: :file
      f.input :category_document
      f.input :projects
    end
    f.actions do
      f.action(:submit)
      f.cancel_link(admin_documents_path)
    end
  end

  index do
    selectable_column
    column :id
    column "Document" do |a|
      link_to(a.document.file.filename, a.document.url, target: '_blank') if a.document.url.present?
    end
    column :name
    column :category_document_id
    column :projects do |p|
      table do
        p.projects.each do |project|
          tr '', class: 'dboard' do
            td do
              link_to project.title, admin_project_path(project.id)
            end
          end
        end
      end
    end
    column :created_at
    column :updated_at
    actions do |a|
    end
  end

  preserve_default_filters!
  remove_filter :document_projects

  show do
    attributes_table do
      row :id
      row :document do |a|
        link_to a.document.file.filename, a.document.url if a.document.url.present?
      end
      row :category_document_id
      row :projects
      row :created_at
      row :updated_at
    end
  end
end
