# Trigger added to database to prevent submission deletion
# CREATE FUNCTION prevent_submission_delete() RETURNS trigger AS $prevent_submission_delete$
# BEGIN
#   RAISE EXCEPTION 'submission cannot be deleted';
#   END;
#   $prevent_submission_delete$ LANGUAGE plpgsql;
#   create trigger club_trigger_0 before delete on submissions
#   FOR EACH ROW EXECUTE PROCEDURE prevent_submission_delete();

# DROP TRIGGER club_trigger_0 ON submissions;
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
    column "Number", :stem_diameter
    column "Length", :health_score
    column "Biomass", :live_leaf_cover
    column "Sex", :live_branch_stem
    column "Price", :dieback
    column :temperature
    column "Wind", :rainfall
    column "Seastate", :humidity
    column "Low", :leaf_tie_month
    column "Rising", :seed_borer
    column "High", :loopers
    column "Falling", :grazing
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
    if resource.valid?
      resource.update_attribute(:status, Submission.statuses[:approved])
      redirect_to admin_submissions_path, :notice => 'Submission approved.' and return
    else
      redirect_to admin_submissions_path, :alert => resource.errors.full_messages.first and return
    end
  end

  member_action :reject_submission, method: :put do
    pn_msg = params[:submission][:reject_comment].to_s.html_safe
    lm = LandManager.find(resource.submitted_by) rescue nil
    msg = "Your survey for sample #{resource.sub_category.name rescue 'N/A'} taken on #{resource.created_at.strftime('%v')} has been rejected."
    lm.send_pn_and_email_notification('Submission Rejected', "#{msg}, Comments:#{pn_msg}") if lm
    resource.update_columns(status: Submission.statuses[:rejected], reject_comment: pn_msg)
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
        # Photo.where(imageable_type: 'Submission',imageable_id: sub.id).delete_all
    end
    redirect_to collection_path, alert: 'All selected submissions rejected.'
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
        f.object.sample_image = Photo.new if f.object.new_record?
        f.object.monitoring_image = Photo.new if f.object.new_record?
        f.has_many :sample_image, heading: 'Sample Photo*', new_record: false do |m|
          m.input :file, :as => :file, :hint => m.object.file.present? \
                        ? image_tag(m.object.file.url(:thumb))
          : content_tag(:span, 'no image selected')

          m.input :file_cache, :as => :hidden
        end
        f.has_many :monitoring_image, heading: 'Monitoring Photo*', new_record: false do |m|
          m.input :file, :as => :file, :hint => m.object.file.present? \
                        ? image_tag(m.object.file.url(:thumb))
          : content_tag(:span, 'no image selected')

          m.input :file_cache, :as => :hidden
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
      f.input :stem_diameter, label: 'Number'
      f.input :health_score,label: "Length", :input_html => { :type => "number" }
      f.input :live_leaf_cover,label:"Biomass", :input_html => { :type => "number" }
      f.input :live_branch_stem, label: "Sex", :input_html => { :type => "number" }
      f.input :dieback, label: "Price", :input_html => { :type => "number" }
      f.input :temperature, label: 'Temperature'
      f.input :rainfall, label: "Wind"
      f.input :humidity, label: 'Seastate'
      f.input :status
      f.inputs "Tide"  do
        f.input :leaf_tie_month, as: :boolean, label: "Low"
        f.input :seed_borer, as: :boolean, label: "Rising"
        f.input :loopers, as: :boolean, label: "High"
        f.input :grazing, as: :boolean, label: "Falling"
      end
      f.input :field_notes, input_html: {rows: 4}
      f.input :sub_category, label: 'Sample', input_html: { class: 'sub_category'}
      f.input :category, label: 'Species'
      f.input :site
      f.input :location
      f.input :project
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
      row "Number" do |o|
        o.stem_diameter
      end
      row "Length" do |o|
        o.health_score
      end
      row "Biomass" do |s|
        s.live_leaf_cover
      end
      row "Sex" do |s|
        s.live_branch_stem
      end
      row "Price" do |s|
        s.dieback
      end

      row :temperature
      row "Wind" do |s|
        s.rainfall
      end
      row "Seastate" do |s|
        s.humidity
      end
      row "Low" do |s|
        s.leaf_tie_month
      end
      row "Rising" do |s|
        s.seed_borer
      end
      row "High" do |s|
        s.loopers
      end
      row "Falling" do |s|
        s.grazing
      end
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
    column "Number" do |s|
      s.stem_diameter
    end
    column "Length" do |s|
      s.health_score
    end
    column "Biomass" do |s|
      s.live_leaf_cover
    end
    column "Sex" do |s|
      s.live_branch_stem
    end
    column "Price" do |s|
      s.dieback
    end
    column :temperature
    column "Wind" do |s|
      s.rainfall
    end
    column "Seastate" do |s|
      s.humidity
    end
    column "Low" do |s|
      s.leaf_tie_month
    end
    column "Rising" do |s|
      s.seed_borer
    end
    column "High" do |s|
      s.loopers
    end
    column "Falling" do |s|
      s.grazing
    end
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
  filter :rainfall, label: "Wind"
  filter :humidity, label: "Seastate"
  filter :temperature
  filter :health_score, label: "Length"
  filter :live_branch_stem, label: "Sex"
  filter :live_leaf_cover, label: "Biomass"
  filter :stem_diameter, label: "Number"
  filter :dieback, label: "Sex"
  filter :leaf_tie_month, label: "Low"
  filter :loopers, label: "Rising"
  filter :seed_borer, label: "Rising"
  filter :grazing, label: "Falling"
  filter :field_notes
  filter :latitude
  filter :longitude
  # filter :approved
  filter :created_at
  filter :updated_at

end