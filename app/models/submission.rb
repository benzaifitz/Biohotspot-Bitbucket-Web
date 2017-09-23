class Submission < ApplicationRecord
  belongs_to :sub_category
  has_many :photos, as: :imageable
  mount_uploader :sample_photo, SamplePhotoUploader
  mount_uploader :monitoring_photo, MonitoringPhotoUploader
  attr_accessor :sample_photo_cache, :monitoring_photo_cache
  accepts_nested_attributes_for :photos, allow_destroy: true
  # validates_presence_of :monitoring_photo, :sample_photo, :sub_category
  validates_numericality_of :health_score,:live_leaf_cover, :live_branch_stem, :dieback, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 5, :message => "Value must be between 1-5", :allow_blank => true

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  after_create :generate_survey_number

  after_commit :save_sample_photo_from_api, if: 'sample_photo_full_url && sample_photo_full_url_changed?'
  after_commit :save_monitoring_photo_from_api, if: 'monitoring_photo_full_url && monitoring_photo_full_url_changed?'

  def save_sample_photo_from_api
    self.update_column(:sample_photo, sample_photo_full_url.split('/').last)
  end

  def save_monitoring_photo_from_api
    self.update_column(:monitoring_photo, monitoring_photo_full_url.split('/').last)
  end

  def monitoring_photo_thumb_url
    self.monitoring_photo_url(:thumb)
  end

  def sample_photo_thumb_url
    self.sample_photo_url(:thumb)
  end

  def generate_survey_number
    self.update_column(:survey_number, "#{self.sub_category_id}+#{self.created_at}")
  end

  def save_by_status(submission_status)
    submission_status == 'incomplete' ? self.save(validate: false) : self.save!
  end
end
