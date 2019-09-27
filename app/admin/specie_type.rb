ActiveAdmin.register SpecieType, as: 'Species Types' do

  # menu label: 'Species Types', priority: 6
  menu label: 'Taxonomy',priority: 5, parent: 'Species'

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


  action_item :view, only: :index do
    link_to 'Import Taxonomy', import_taxonomy_admin_species_types_path
  end

  collection_action :import_taxonomy do
  end
  collection_action :import, method: 'post' do
    byebug
    if params[:taxonomy].blank? || params[:taxonomy].original_filename.split(".").last != "csv"
      redirect_to :back, alert: "Please select a csv file"
    else
      csv_table = CSV.read(params[:taxonomy].path, :headers => true, encoding: 'iso-8859-1:utf-8')
      csv_table.delete("created_at")
      csv_table.delete("updated_at")  
      total_count = csv_table.count
      success_count = 0
      errors = []
      begin
        csv_table.each do |row|
          # next if row.to_hash['name'].blank?
          tax_hash = row.to_hash.transform_keys(&:downcase).transform_keys{|k| k.to_s.gsub(" ", "_")}
     
byebug
          taxonomy = SpecieType.new(tax_hash)  

          if taxonomy.save
            success_count += 1
          else
            errors << taxonomy.errors.full_messages.first
          end
        end
        if errors.length > 0
          errors = errors.uniq.join("\n")
          redirect_to "/admin/species_types", alert: "#{success_count}/#{total_count} Taxonomy were imported.\n #{errors}"
        else
          redirect_to "/admin/species_types", notice: "#{success_count}/#{total_count} Taxonomy were imported."  
        end
        
      rescue => error
        redirect_to :back, alert: error.message
      end
    end
  end  

  csv do
    column :name
    column :phylum
    column :klass
    column :order
    column :superfamily
    column :family
    column :genus
    column :species
    column :sub_species
    column :created_at
  end    


  filter :name
  filter :created_at

end