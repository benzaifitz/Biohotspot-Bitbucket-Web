class Photo < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  belongs_to :submission, -> { where( photos: { imageable_type: 'Submission' } ).includes( :photos ) }, foreign_key: 'imageable_id'

  mount_uploader :file, PhotoUploader

  validates :file,
            :file_size => {
                :maximum => 2.0.megabytes.to_i
            }
  # belongs_to :category

  after_commit :save_images_from_api, if: 'url && url_changed?'

  def save_images_from_api
    self.update_column(:file, url.split('/').last)
  end



  ransacker :submission_sub_category,
    formatter: proc { |v|
      submissions = SubCategory.find(v).submissions rescue nil
      data = submissions.map(&:photos).flatten.map(&:id) rescue nil
      data = data.present? ? data : nil
    }, splat_params: true do |parent|
    parent.table[:id]
  end

  ransacker :submission_category,
            formatter: proc { |v|
              sub_categories = Category.find(v).sub_categories rescue nil
              data = sub_categories.map(&:submissions).flatten.map(&:photos).flatten.map(&:id) rescue nil
              data = data.present? ? data : nil
            }, splat_params: true do |parent|
    parent.table[:id]
  end

  def file_thumb_url
    self.file_url(:thumb)
  end

end
