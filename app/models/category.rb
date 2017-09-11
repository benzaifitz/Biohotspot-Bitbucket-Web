class Category < ApplicationRecord
  # TO access all categories by default use without_default_scope: true
  # Or to get all client use Category.unscoped
  acts_as_paranoid
  belongs_to :site
  attr_accessor :file_cache
  has_many :sub_categories
  has_many :photos, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :photos, allow_destroy: true
  serialize :tags
  LIMIT = 5

  validate do |record|
    record.validate_photo_quota
  end

  def validate_photo_quota
    message = I18n.t("exceeded_quota")
    groups_length = 0
    if photos.present?
      groups_length = photos.reject(&:marked_for_destruction?).length
    end
    errors.add(:base, message) if groups_length > LIMIT
  end
end
