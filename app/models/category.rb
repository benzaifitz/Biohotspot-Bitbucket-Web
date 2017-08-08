class Category < ApplicationRecord
  belongs_to :site

  has_many :sub_categories
  has_many :photos
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
