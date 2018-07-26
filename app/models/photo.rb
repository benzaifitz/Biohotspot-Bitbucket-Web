# CREATE FUNCTION prevent_photo_delete() RETURNS trigger AS $prevent_photo_delete$
# BEGIN
#   RAISE EXCEPTION 'photo cannot be deleted';
#   END;
#   $prevent_photo_delete$ LANGUAGE plpgsql;
#   create trigger prevent_photo_delete_trigger_0 before delete on photos
#   FOR EACH ROW EXECUTE PROCEDURE prevent_photo_delete();
#DROP TRIGGER prevent_photo_delete_trigger_0 ON photos;
class Photo < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  belongs_to :submission, -> { where( photos: { imageable_type: 'Submission' } ).includes( :photos ) }, foreign_key: 'imageable_id'
  belongs_to :category, -> { where( photos: { imageable_type: ["Category", "Submission"] } ).includes( :photos ) }, foreign_key: 'imageable_id'

  attr_accessor :crop_h, :crop_w, :crop_x, :crop_y
  mount_uploader :file, PhotoUploader
  # crop_uploaded :file

  ADDITIONAL_IMAGES = 'additional'
  SAMPLE_IMAGE = 'sample'
  MONITORING_IMAGE = 'monitoring'

  # validates :file,
  #           :file_size => {
  #               :maximum => 2.0.megabytes.to_i
  #           }
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
              id = v.to_i
              ids = []
              Photo.where("imageable_type in (?)", ["Submission", "Category"]).each do |photo|
                if photo.imageable_type == "Category"
                  ids << photo.id if photo.imageable_id == id
                else
                  ids << photo.id if photo.imageable.category.id == id
                end
              end
              data = ids.present? ? ids : nil
            }, splat_params: true do |parent|
    parent.table[:id]
  end

  def file_thumb_url
    self.file_url(:thumb)
  end

end
