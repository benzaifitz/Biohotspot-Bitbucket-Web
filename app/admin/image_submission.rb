ActiveAdmin.register Photo, as: "Sample Image" do

  menu label: 'Sample Images', parent: 'Submissions', priority: 4

  actions :index

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
      link_to p.imageable.id, admin_submission_path(p.imageable.id)
    end
    column :sub_category do |p|
      link_to p.imageable.sub_category.name, admin_sample_path(p.imageable.sub_category.id) if p.imageable.sub_category
    end
    column :category do |p|
      link_to p.imageable.sub_category.category.name, admin_category_path(p.imageable.sub_category.category.id) if p.imageable.sub_category
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
      item 'Approve', approve_admin_sample_image_path(p), method: :put if !p.approved?
      (item 'Reject', reject_admin_sample_image_path(p), class: 'fancybox member_link', data: { 'fancybox-type' => 'ajax' }) if p.approved?
    end
  end

  member_action :approve, method: :put do
    resource.update_columns(approved: true)
    redirect_to admin_sample_images_path, :notice => 'Photo approved.' and return
  end

  member_action :reject_image, method: :put do
    pn_msg = params[:photo][:reject_comment].to_s.html_safe
    lm = LandManager.where(id: Photo.find(resource.id).submission.submitted_by).first rescue nil
    lm.send_photo_rejected_pn(pn_msg) if lm
    resource.update_columns(approved: false, reject_comment: pn_msg)
    redirect_to admin_sample_images_path, :notice => 'Photo rejected.' and return
  end

  member_action :reject, method: :get do
    render template: 'admin/image_submissions/reject', layout: false
  end

  controller do
    def scoped_collection
      Photo.joins(:submission).where("file is not null or url != ''")
    end
  end

  filter :created_at
  filter :submission_sub_category_in, as: :select, collection: -> {SubCategory.all.map{|s| [s.name, s.id]}}
  filter :submission_category_in, as: :select, collection: -> {Category.all.map{|s| [s.name, s.id]}}

end