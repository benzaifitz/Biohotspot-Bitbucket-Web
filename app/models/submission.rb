class Submission < ApplicationRecord
  belongs_to :sub_category
  belongs_to :category
  belongs_to :site
  belongs_to :location
  belongs_to :project
  has_many :photos, -> { where(imageable_sub_type: Photo::ADDITIONAL_IMAGES)}, as: :imageable
  # has_many :additional_images, -> { where(imageable_sub_type: Photo::ADDITIONAL_IMAGES)}, as: :imageable
  has_one :sample_image, -> { where(imageable_sub_type: Photo::SAMPLE_IMAGE)}, as: :imageable, class_name: 'Photo'
  has_one :monitoring_image, -> { where(imageable_sub_type: Photo::MONITORING_IMAGE)}, as: :imageable, class_name: 'Photo'
  # mount_uploader :sample_photo, SamplePhotoUploader
  # mount_uploader :monitoring_photo, MonitoringPhotoUploader
  attr_accessor :sample_photo_cache, :monitoring_photo_cache
  accepts_nested_attributes_for :photos#, allow_destroy: true
  # accepts_nested_attributes_for :additional_images, allow_destroy: true
  accepts_nested_attributes_for :sample_image#, allow_destroy: true
  accepts_nested_attributes_for :monitoring_image#, allow_destroy: true
  # validates_presence_of :monitoring_photo, :sample_photo, :sub_category
  # validates_numericality_of :health_score,:live_leaf_cover, :live_branch_stem, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 5, :message => "Value must be between 1-5", :allow_blank => true
  # validates_numericality_of :dieback, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 5, :message => "Value must be between 0-5", :allow_blank => true

  enum status: [ :submitted, :approved, :rejected ]

  # before_validation :convert_data_type
  # enum status: [:complete, :incomplete]
  reverse_geocoded_by :latitude, :longitude
  before_save :reverse_geocode
  before_save :assign_site_location

  after_create :generate_survey_number

  # after_save :save_sample_photo_from_api, if: 'sample_photo_full_url && sample_photo_full_url_changed?'
  # after_save :save_monitoring_photo_from_api, if: 'monitoring_photo_full_url && monitoring_photo_full_url_changed?'

  def assign_site_location
    self.site = self.sub_category.site rescue nil
    self.location = self.sub_category.site.location rescue nil
  end

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

  def save_by_status
    self.save(validate: false)
    # incomplete? ? self.save(validate: false) : self.save!
  end

  def convert_data_type
    self.health_score = self.health_score.to_f
    self.live_leaf_cover = self.live_leaf_cover.to_f
    self.live_branch_stem = self.live_branch_stem.to_f
    self.dieback = self.dieback.to_f
  end

  def self.submission_status(sample, specie)
    return nil if (sample.blank? || sample.id.blank?)
    Submission.where(sub_category_id: (sample.id rescue nil), category_id: (specie.id rescue nil),
                     site_id: (sample.site.id rescue nil), location_id: (sample.site.location.id rescue nil),
                     project_id: (sample.site.location.project.id rescue nil) ).last.status rescue nil

  end

end
