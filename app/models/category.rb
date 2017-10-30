class Category < ApplicationRecord
  # TO access all categories by default use without_default_scope: true
  # Or to get all client use Category.unscoped
  acts_as_paranoid
  # belongs_to :site

  has_many :category_sub_categories
  has_many :sub_categories, :through => :category_sub_categories
  accepts_nested_attributes_for :category_sub_categories #, :allow_destroy => true

  has_many :project_categories
  has_many :projects, :through => :project_categories
  accepts_nested_attributes_for :project_categories #, :allow_destroy => true

  attr_accessor :file_cache

  # has_many :sub_categories
  has_many :photos, as: :imageable #, dependent: :destroy
  accepts_nested_attributes_for :photos #, allow_destroy: true

  serialize :tags
  LIMIT = 5
  validates_uniqueness_of :name

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

  def current_user_sub_catrgories(current_user_id)
    sub_categories_ids = Submission.where.not(sub_category_id: nil).
        where(submitted_by: current_user_id).
        map(&:sub_category_id).flatten.compact
    sub_categories_ids = sub_categories_ids + self.sub_categories#.map{|sc| sc.id if sc.submission.blank?}
    self.sub_categories.where(id: sub_categories_ids.uniq)
  end

  def current_user_site(current_user)
    self.sites.where(location_id: current_user.location_id).first
  end

end
