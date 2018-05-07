class SpecieType < ApplicationRecord
  has_many :categories
  before_destroy :can_destroy?

  private

  def can_destroy?
    unless categories.blank?
      errors[:base] << "You can not delete this record as there are some records depending on this!"
      throw :abort
    end
  end
end
