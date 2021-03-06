ActiveAdmin.register Document, namespace: :pm do

  menu label: 'Document List', parent: 'Documents'

  permit_params do
    [:name, :document, :category_document_id, project_ids: []]
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Document Details' do
      f.input :name
      f.input :document, as: :file
      f.input :category_document
      f.input :projects, as: :select, collection: current_project_manager.projects
    end
    f.actions do
      f.action(:submit)
      f.cancel_link(pm_documents_path)
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
        p.projects.where("projects.id in (?)", current_project_manager.projects.pluck(:id)).each do |project|
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

  filter :projects, as: :select, collection: proc{current_project_manager.projects.pluck(:title, :id)}
  filter :category_document, as: :select, collection: proc{current_project_manager.category_documents.pluck(:name, :id)}
  
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
