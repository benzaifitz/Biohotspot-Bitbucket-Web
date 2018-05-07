ActiveAdmin.register SpecieType do

  menu label: 'Species Types', priority: 6

  permit_params do
    allowed = [:name]
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

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Specie type details' do
      f.input :name
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :created_at
      row :updated_at
    end
  end

  controller do
    def destroy
      if resource.categories.blank?
        resource.destroy
        flash[:notice] = 'You have successfully deleted this specie type'
        redirect_to admin_specie_types_path
      else
        flash[:alert] = 'You can not delete this record as there are some records depending on this!'
        redirect_to admin_specie_types_path
      end
    end  
  end

  filter :name
  filter :created_at

end