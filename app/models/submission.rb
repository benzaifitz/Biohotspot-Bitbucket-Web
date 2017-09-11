class Submission < ApplicationRecord
  belongs_to :sub_category
  has_many :photos, as: :imageable
  mount_uploader :sample_photo, SamplePhotoUploader
  mount_uploader :monitoring_photo, MonitoringPhotoUploader
  attr_accessor :sample_photo_cache, :monitoring_photo_cache
  accepts_nested_attributes_for :photos, allow_destroy: true
  validates_presence_of :monitoring_photo, :sample_photo
  validates_numericality_of :health_score,:live_leaf_cover, :live_branch_stem, :dieback, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 5, :message => "Value must be between 1-5", :allow_blank => true

  def monitoring_photo_thumb_url
    self.monitoring_photo_url(:thumb)
  end

  def sample_photo_thumb_url
    self.sample_photo_url(:thumb)
  end
end
