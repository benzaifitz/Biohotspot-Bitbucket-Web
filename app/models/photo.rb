class Photo < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  belongs_to :submission, -> { where( photos: { imageable_type: 'Submission' } ).includes( :photos ) }, foreign_key: 'imageable_id'

  attr_accessor :crop_h, :crop_w, :crop_x, :crop_y
  mount_uploader :file, PhotoUploader
  # crop_uploaded :file

  ADDITIONAL_IMAGES = 'additional'
  SAMPLE_IMAGE = 'sample'
  MONITORING_IMAGE = 'monitoring'

  validates :file,
            :file_size => {
                :maximum => 2.0.megabytes.to_i
            }
  # belongs_to :category

  after_save :save_images_from_api, if: 'url && url_changed?'

  def save_images_from_api
    self.update_column(:file, url.split('/').last)
  end



  ransacker :submission_sub_category,
    formatter: proc { |v|
      submission = SubCategory.find(v).submission rescue nil
      data = Photo.where(imageable_id: submission.id, imageable_type: 'Submission').map(&:id) rescue nil
      data = data.present? ? data : nil
    }, splat_params: true do |parent|
    parent.table[:id]
  end

  ransacker :submission_category,
            formatter: proc { |v|
              sub_categories = Category.find(v).sub_categories rescue nil
              submission_ids = sub_categories.map(&:submission).flatten.map(&:id) rescue nil
              data = Photo.where(imageable_id: submission_ids, imageable_type: 'Submission').map(&:id) rescue nil
              data = data.present? ? data : nil
            }, splat_params: true do |parent|
    parent.table[:id]
  end

  def file_thumb_url
    self.file_url(:thumb)
  end

end
