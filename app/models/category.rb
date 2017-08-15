class Category < ApplicationRecord
  # TO access all categories by default use without_default_scope: true
  # Or to get all client use Category.unscoped
  acts_as_paranoid
  belongs_to :site

  has_many :sub_categories
  has_many :photos, as: :imageable
  serialize :tags
  LIMIT = 5

  validate do |record|
    record.validate_photo_quota
  end

  def validate_photo_quota
    return unless site
    if photos(:reload).count >= LIMIT
      errors.add(:base, :exceeded_quota)
    end
  end
end
