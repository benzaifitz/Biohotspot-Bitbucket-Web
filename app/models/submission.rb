class Submission < ApplicationRecord
  belongs_to :sub_category
  has_many :photos, as: :imageable
  mount_uploader :sample_photo, SamplePhotoUploader
  mount_uploader :monitoring_photo, MonitoringPhotoUploader
  accepts_nested_attributes_for :photos, allow_destroy: true
  validates_presence_of :monitoring_photo

end
