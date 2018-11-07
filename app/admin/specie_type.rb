ActiveAdmin.register SpecieType, as: 'Species Types' do

  menu label: 'Species Types', priority: 6

  permit_params do
    allowed = [:id, :name, :phylum, :klass, :order, :superfamily, :family, :genus, :species, :sub_species]
    allowed.uniq
  end

  actions :all

  index do
    selectable_column
    id_column
    column :name
    column :phylum
    column 'Class', :klass
    column :order
    column :superfamily
    column :family
    column :genus
    column :species
    column :sub_species
    column :created_at
    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Species Type Details' do
      f.input :name
      f.input :phylum
      f.input :klass, label: 'Class'
      f.input :order
      f.input :superfamily
      f.input :family
      f.input :genus
      f.input :species
      f.input :sub_species
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :phylum
      row 'Class' do |r|
        r.klass
      end
      row :order
      row :superfamily
      row :family
      row :genus
      row :species
      row :sub_species
      row :created_at
      row :updated_at
    end
  end
  filter :name
  filter :created_at

end