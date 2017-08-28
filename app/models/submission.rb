class Submission < ApplicationRecord
  belongs_to :sub_category
  has_many :photos, as: :imageable
  accepts_nested_attributes_for :photos, allow_destroy: true
  LIMIT = 5

  validate do |record|
    record.validate_photo_quota
  end

  def validate_photo_quota
    message = I18n.t("exceeded_quota")
    submission_length = 0
    if photos.present?
      submission_length = photos.reject(&:marked_for_destruction?).length
    end
    errors.add(:base, message) if submission_length > LIMIT
  end
end
