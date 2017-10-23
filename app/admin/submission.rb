ActiveAdmin.register Submission, as: 'Sample List' do

  menu label: 'Sample List', parent: 'Submissions', priority: 1

  permit_params :sub_category_id, :survey_number, :submitted_by, :sub_category, :rainfall, :humidity, :temperature,
                :health_score, :live_leaf_cover, :live_branch_stem, :stem_diameter, :sample_photo, :monitoring_photo, :dieback,
                :leaf_tie_month, :seed_borer, :loopers, :grazing, :field_notes, :status,
                monitoring_image_attributes: [ :id, :file, :url, :imageable_id, :imageable_type, :imageable_sub_type, :_destroy ],
                sample_image_attributes: [ :id, :file, :url, :imageable_id, :imageable_type, :imageable_sub_type, :_destroy ],
                photos_attributes: [ :id, :file, :url, :imageable_id, :imageable_type, :imageable_sub_type, :_destroy ]
  actions :all

  index do
    selectable_column
    id_column
    column 'Sample' do |s|
      sc = s.try(:sub_category)
      link_to(sc.name, admin_sample_path(sc.id)) if sc
    end
    column 'Site' do |s|
      site = s.try(:sub_category).try(:category).try(:site)
      link_to(site.title, admin_site_path(site.id)) if site
    end
    column 'Project' do |s|
      project = s.try(:sub_category).try(:category).try(:site).try(:project)
      link_to(project.title, admin_site_path(project.id)) if project
    end
    column :stem_diameter
    column :health_score
    column :live_leaf_cover
    column :live_branch_stem
    column :dieback
    column :temperature
    column :rainfall
    column :humidity
    column :leaf_tie_month
    column :seed_borer
    column :loopers
    column :grazing
    column :field_notes
    column :survey_number
    column :submitted_by do |s|
      u = User.find(s.submitted_by) rescue nil
      link_to(u.full_name, admin_user_path(u.id)) if u
    end
    column :address
    column :latitude
    column :longitude
    column :created_at
    actions do |p|
      item 'Approve', approve_admin_sample_list_path(p), method: :put if !p.approved?
      (item 'Reject', reject_admin_sample_list_path(p), class: 'fancybox member_link', data: { 'fancybox-type' => 'ajax' }) if p.approved?
    end
  end

  member_action :approve, method: :put do
    resource.update_columns(approved: true)
    redirect_to admin_sample_lists_path, :notice => 'Submission approved.' and return
  end

  member_action :reject_submission, method: :put do
    pn_msg = params[:submission][:reject_comment].to_s.html_safe
    lm = LandManager.find(resource.submitted_by) rescue nil
    lm.send_pn_and_email_notification('Submission Rejected', pn_msg) if lm
    resource.update_columns(approved: false, reject_comment: pn_msg)
    Photo.where(imageable_type: 'Submission',imageable_id: resource.id).delete_all
    redirect_to admin_sample_lists_path, :notice => 'Submission rejected.' and return
  end

  member_action :reject, method: :get do
    render template: 'admin/submissions/reject', layout: false
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.has_many :sample_image, heading: 'Sample Photos', new_record: false do |pm|
        pm.input :file, :as => :file, :hint => pm.object.file.present? \
                        ? image_tag(pm.object.file.url(:thumb))
                      : content_tag(:span, 'no image selected')

        pm.input :file_cache, :as => :hidden
      end
      f.has_many :monitoring_image, heading: 'Monitoring Photos', new_record: false do |pm|
        pm.input :file, :as => :file, :hint => pm.object.file.present? \
                        ? image_tag(pm.object.file.url(:thumb))
                      : content_tag(:span, 'no image selected')

        pm.input :file_cache, :as => :hidden
      end
      # f.inputs "Sample Picture", :multipart => true do
      #   f.input :sample_photo, as: :file
      #   f.input :sample_photo_cache, :as => :hidden
      #   insert_tag(Arbre::HTML::Li, class: 'file input optional') do
      #     insert_tag(Arbre::HTML::P, class: 'inline-hints') do
      #       insert_tag(Arbre::HTML::Img, id: 'picture_preview', height: '100px', src: "#{f.object.sample_photo.url(:thumb)}?#{Random.rand(100)}")
      #     end
      #   end
      # end
      # f.inputs "Monitoring Picture", :multipart => true do
      #   f.input :monitoring_photo, as: :file
      #   f.input :monitoring_photo_cache, :as => :hidden
      #   insert_tag(Arbre::HTML::Li, class: 'file input optional') do
      #     insert_tag(Arbre::HTML::P, class: 'inline-hints') do
      #       insert_tag(Arbre::HTML::Img, id: 'monitoring_picture_preview', height: '100px', src: "#{f.object.monitoring_photo.url(:thumb)}?#{Random.rand(100)}")
      #     end
      #   end
      # end
      f.has_many :photos, heading: 'Additional Photos', allow_destroy: true do |pm|
        pm.input :file, :as => :file, :hint => pm.object.file.present? \
                        ? image_tag(pm.object.file.url(:thumb))
                      : content_tag(:span, 'no image selected')

        pm.input :file_cache, :as => :hidden
      end
      f.input :stem_diameter, label: 'Stem diameter (trunk)'
      f.input :health_score, :input_html => { :type => "number" }
      f.input :live_leaf_cover, :input_html => { :type => "number" }
      f.input :live_branch_stem, :input_html => { :type => "number" }
      f.input :dieback, :input_html => { :type => "number" }
      f.input :temperature, label: 'Temperature (ave for previous month)'
      f.input :rainfall
      f.input :humidity, label: 'Temperature (ave for previous month)'
      f.input :status
      f.inputs "IS THE FOLLOWING ON THE PLANT?"  do
        f.input :leaf_tie_month, as: :boolean
        f.input :seed_borer, as: :boolean
        f.input :loopers, as: :boolean
        f.input :grazing, as: :boolean
      end
      f.input :field_notes
      f.input :sub_category, input_html: { class: 'sub_category'}
      f.input :submitted_by, :as => :select, :collection => LandManager.all.collect {|lm| [lm.full_name, lm.id] }
      actions
    end
  end

  show do |submission|
    attributes_table do
      row :id
      row 'Sample' do |s|
        s.try(:sub_category).try(:name)
      end
      row 'Site' do |s|
        s.try(:sub_category).try(:category).try(:site).try(:title)
      end
      row 'Project' do |s|
        s.try(:sub_category).try(:category).try(:site).try(:project).try(:title)
      end
      row :sample_photo do |a|
        link_to(image_tag(a.sample_image.file.url(:thumb), height: '100px'),a.sample_image.file.url, target: '_blank') if a.sample_image && a.sample_image.file && a.sample_image.file.url.present?
      end
      row :monitoring_photo do |a|
        link_to(image_tag(a.monitoring_image.file.url(:thumb), height: '100px'),a.monitoring_image.file.url, target: '_blank')  if  a.monitoring_image && a.monitoring_image.file && a.monitoring_image.file.url.present?
      end
      row "Additional Photos" do
        images = submission.photos.map do |photo|
          link_to(image_tag(photo.try(:file).url(:thumb), height: '100px'),photo.file.url, target: '_blank') if photo.file && photo.file.url.present?
        end
        images.join("<br><br>").html_safe
      end
      row :stem_diameter
      row :health_score
      row :live_leaf_cover
      row :live_branch_stem
      row :dieback
      row :temperature
      row :rainfall
      row :humidity
      row :leaf_tie_month
      row :seed_borer
      row :loopers
      row :grazing
      row :field_notes
      row :survey_number
      row :submitted_by
      row :address
      row :latitude
      row :longitude
      row :created_at
      row :updated_at

    end
  end

  csv do
    column 'Sample' do |s|
      s.try(:sub_category).try(:name)
    end
    column 'Site' do |s|
      s.try(:sub_category).try(:category).try(:site).try(:title)
    end
    column 'Project' do |s|
      s.try(:sub_category).try(:category).try(:site).try(:project).try(:title)
    end
    column :stem_diameter
    column :health_score
    column :live_leaf_cover
    column :live_branch_stem
    column :dieback
    column :temperature
    column :rainfall
    column :humidity
    column :leaf_tie_month
    column :seed_borer
    column :loopers
    column :grazing
    column :field_notes
    column :survey_number
    column :submitted_by
    column :address
    column :latitude
    column :longitude
    column :created_at
    column :updated_at
  end
  
  filter :sub_category, label: 'Sample'
  filter :survey_number
  filter :submitted_by, as: :select, collection: ->{LandManager.all.map{|lm| [lm.full_name, lm.id]}}
  filter :rainfall
  filter :humidity
  filter :temperature
  filter :health_score
  filter :live_branch_stem
  filter :live_leaf_cover
  filter :stem_diameter
  filter :dieback
  filter :leaf_tie_month
  filter :loopers
  filter :seed_borer
  filter :grazing
  filter :field_notes
  filter :latitude
  filter :longitude
  # filter :approved
  filter :created_at

end