ActiveAdmin.register Feedback, namespace: :pm do
menu false #label: 'Feedback',priority: 5, parent: 'Communication'
  actions :index

  index do
    selectable_column
    id_column
    column :comment
    column :created_at
  end

end