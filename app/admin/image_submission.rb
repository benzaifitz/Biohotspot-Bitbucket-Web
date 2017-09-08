ActiveAdmin.register Photo, as: "Image Submission" do

  menu label: 'Image Submissions List', parent: 'Submissions', priority: 2

  actions :index

  index do
    column :id
    column 'Image' do |p|
      image_tag p.file.url, style: 'width:80px'
    end
    column :submission do |p|
      link_to p.imageable.id, admin_submission_path(p.imageable.id)
    end
    column :sub_category do |p|
      link_to p.imageable.sub_category.name, admin_sub_category_path(p.imageable.sub_category.id)
    end
    column :category do |p|
      link_to p.imageable.sub_category.category.name, admin_category_path(p.imageable.sub_category.category.id)
    end
  end

  controller do
    def scoped_collection
      Photo.joins(:submission).where("file is not null or url != ''")
    end
  end

  filter :submission_sub_category_in, as: :select, collection: -> {SubCategory.all.map{|s| [s.name, s.id]}}
  filter :submission_category_in, as: :select, collection: -> {Category.all.map{|s| [s.name, s.id]}}

end