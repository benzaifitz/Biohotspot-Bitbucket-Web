ActiveAdmin.register Submission do

  menu label: 'Submissions', priority: 6

  permit_params :sub_category_id, :category_id, :site_id, :location_id, :project_id, :survey_number, :submitted_by,
                :sub_category, :rainfall, :humidity, :temperature,
                :health_score, :live_leaf_cover, :live_branch_stem, :stem_diameter, :sample_photo, :monitoring_photo, :dieback,
                :leaf_tie_month, :seed_borer, :loopers, :grazing, :field_notes, :status,
                monitoring_image_attributes: [ :id, :file, :url, :imageable_id, :imageable_type, :imageable_sub_type, :_destroy ],
                sample_image_attributes: [ :id, :file, :url, :imageable_id, :imageable_type, :imageable_sub_type, :_destroy ],
                photos_attributes: [ :id, :file, :url, :imageable_id, :imageable_type, :imageable_sub_type, :_destroy ]

  actions :all, except: [:destroy, :delete]

  # action_item :new, only: [:show,:index], label: 'Manual Entry'
  config.action_items[0] = ActiveAdmin::ActionItem.new only: [:show,:index] do
    link_to 'Manual Entry', new_admin_submission_path
  end
  index do
    selectable_column
    id_column
    column 'Sample' do |s|
      sc = s.try(:sub_category)
      link_to(sc.name, admin_sample_path(sc.id)) if sc
    end
    column 'Species' do |s|
      link_to(s.category.name, admin_species_path(s.category.id)) rescue nil
    end
    column :site
    column :location
    column :project
    column 'Status' do |p|
      if p.approved?
        status_tag('active', :ok, class: 'green', label: 'APPROVED')
      elsif p.rejected?
        status_tag('active', :ok, class: 'red', label: 'REJECTED')
      elsif p.submitted?
        status_tag('active', :ok, class: 'orange', label: 'SUBMITTED')
      else
        status_tag('error', :ok, class: 'important', label: 'UNKNOWN')
      end
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
    column :updated_at
    actions do |p|
      (item 'Approve', approve_admin_submission_path(p), method: :put)
      (item 'Reject', reject_admin_submission_path(p), class: 'fancybox member_link', style: 'padding-left: 5px', data: { 'fancybox-type' => 'ajax' })
    end
  end

  member_action :approve, method: :put do
    resource.approved!
    redirect_to admin_submissions_path, :notice => 'Submission approved.' and return
  end

  member_action :reject_submission, method: :put do
    pn_msg = params[:submission][:reject_comment].to_s.html_safe
    lm = LandManager.find(resource.submitted_by) rescue nil
    msg = "Your survey for sample #{resource.sub_category.name rescue 'N/A'} taken on #{resource.created_at.strftime('%v')} has been rejected."
    lm.send_pn_and_email_notification('Submission Rejected', "#{msg}, Comments:#{pn_msg}") if lm
    resource.update_columns(status: Submission.statuses[:rejected], reject_comment: pn_msg)
    Photo.where(imageable_type: 'Submission',imageable_id: resource.id).delete_all
    redirect_to admin_submissions_path, :notice => 'Submission rejected.' and return
  end

  member_action :reject, method: :get do
    render template: 'admin/submissions/reject', layout: false
  end

  batch_action :approve do |ids|
    Submission.where(id: ids).update_all(status: Submission.statuses[:approved])
    redirect_to collection_path, notice: 'All selected submissions approved.'
  end

  batch_action :reject do |ids|
    Submission.where(id: ids).update_all(status: Submission.statuses[:rejected], reject_comment: 'Batch reject.')
    batch_action_collection.find(ids).each do |sub|
        lm = LandManager.find(sub.submitted_by) rescue nil
        msg = "Your survey for sample #{sub.sub_category.name} taken on #{sub.created_at.strftime('%v')} has been rejected."
        lm.send_pn_and_email_notification('Submission Rejected', msg) if lm
        Photo.where(imageable_type: 'Submission',imageable_id: sub.id).delete_all
    end
    redirect_to collection_path, alert: 'All selected submissions rejected.'
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
        f.object.sample_image = Photo.new if f.object.new_record?
        f.object.monitoring_image = Photo.new if f.object.new_record?
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
        f.has_many :photos, heading: 'Additional Photos', allow_destroy: true do |pm|
          pm.input :file, :as => :file, :hint => pm.object.file.present? \
                        ? image_tag(pm.object.file.url(:thumb))
                        : content_tag(:span, 'no image selected')

          pm.input :file_cache, :as => :hidden
        end
        if !f.object.new_record?
          render partial: 'admin/submissions/slider'
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
      f.input :field_notes, input_html: {rows: 4}
      f.input :sub_category, label: 'Sample', input_html: { class: 'sub_category'}
      f.input :category, label: 'Species'
      # f.input :site
      # f.input :location
      # f.input :project
      f.input :submitted_by, :as => :select, :collection => LandManager.all.collect {|lm| [lm.full_name, lm.id] }
    end
    f.actions
  end

  show do |submission|
    attributes_table do
      row :id
      row 'Sample' do |s|
        s.try(:sub_category).try(:name)
      end
      row 'Species' do |s|
        link_to(s.category.name, admin_species_path(s.category.id)) rescue nil
      end
      row :site
      row :location
      row :project
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
    column 'Species' do |s|
      link_to(s.category.name, admin_species_path(s.category.id)) rescue nil
    end
    column :site
    column :location
    column :project
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
  
  filter :sub_category, label: 'Sample', as: :select, multiple: true
  filter :site, as: :select, multiple: true
  filter :location, as: :select, multiple: true
  filter :project, as: :select, multiple: true
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
  filter :updated_at

end