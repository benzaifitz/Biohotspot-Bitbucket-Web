ActiveAdmin.register Photo, as: "Sample Image", namespace: :pm do

  menu label: ' Sample Images', priority: 8, parent: 'Data'
  index do
    column :id
    column 'Image' do |p|
      image_tag(p.file.url, style: 'width:80px') if p.file && p.file.url
    end
    column 'Type' do |p|
      if p.imageable_sub_type == Photo::ADDITIONAL_IMAGES
        status_tag('active', :ok, class: 'green', label: Photo::ADDITIONAL_IMAGES.upcase)
      elsif p.imageable_sub_type == Photo::SAMPLE_IMAGE
        status_tag('eactiverror', :ok, class: 'orange', label: Photo::SAMPLE_IMAGE.upcase)
      elsif p.imageable_sub_type == Photo::MONITORING_IMAGE
        status_tag('active', :ok, class: 'red', label: Photo::MONITORING_IMAGE.upcase)
      else
        status_tag('error', :ok, class: 'important', label: 'UNKNOWN')
      end
    end
    column :submission do |p|
      link_to(p.imageable.id, pm_submission_path(p.imageable.id)) rescue nil
    end
    column 'Sample' do |p|
      link_to(p.imageable.sub_category.name, pm_sample_path(p.imageable.sub_category_id)) rescue nil
    end
    column 'Species' do |p|
      link_to(p.imageable.category.name, pm_species_path(p.imageable.category_id)) rescue nil
    end
    column 'Reject Comment' do |p|
      p.reject_comment if !p.approved?
    end
    column :created_at
    column 'Status' do |p|
      if p.approved?
        status_tag('active', :ok, class: 'important', label: 'Approved')
      else
        status_tag('error', :ok, class: 'important', label: 'Rejected')
      end
    end
    actions do |p|
      item 'Approve', approve_pm_sample_image_path(p), method: :put if !p.approved?
      (item 'Reject', reject_pm_sample_image_path(p), class: 'fancybox member_link', data: { 'fancybox-type' => 'ajax' }) if p.approved?
    end
  end

  member_action :approve, method: :put do
    resource.update_columns(approved: true)
    redirect_to pm_sample_images_path, :notice => 'Photo approved.' and return
  end

  member_action :reject_image, method: :put do
    pn_msg = params[:photo][:reject_comment].to_s.html_safe
    lm = LandManager.where(id: Photo.find(resource.id).imageable.submitted_by).first rescue nil
    lm.send_pn_and_email_notification('Photo Rejected', pn_msg) if lm
    resource.update_columns(approved: false, reject_comment: pn_msg)
    redirect_to pm_sample_images_path, :notice => 'Photo rejected.' and return
  end

  member_action :reject, method: :get do
    render template: 'admin/image_submissions/reject', layout: false
  end

  controller do
    def scoped_collection
      Photo.joins(:submission).where("file is not null or url != ''")
    end
  end

  collection_action :slider, method: :get do
    if !params[:q].blank?
      photos = Photo.ransack(params[:q])
      photos.sorts = ['created_at asc'] if photos.sorts.empty?
      @photos = photos.result
    end
    render template: 'admin/image_submissions/slider', layout: false
  end

  action_item :view_full_size, only: :index do
    path = slider_pm_sample_images_path
    q_p = {q: params.to_unsafe_h[:q].to_h}.to_query
    path += "/?#{q_p}"
    link_to('View Full Size', path, class: 'fancybox slider_fancybox', data: { 'fancybox-type' => 'ajax' })
  end

  filter :created_at
  filter :submission_sub_category_in, label: 'Sample', as: :select,collection: proc{current_project_manager.sub_categories.pluck(:name, :id)}
  filter :submission_category_in, label: 'Species', as: :select,collection: proc{current_project_manager.categories.pluck(:name, :id)}
  filter :imageable_sub_type, label: 'Image Type', as: :select, collection: [Photo::ADDITIONAL_IMAGES,Photo::MONITORING_IMAGE,Photo::SAMPLE_IMAGE]

end