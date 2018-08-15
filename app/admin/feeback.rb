ActiveAdmin.register Feedback do

  actions :index

  index do
    selectable_column
    id_column
    column :comment
    column :created_at
  end

end