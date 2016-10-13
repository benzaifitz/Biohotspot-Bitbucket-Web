# == Schema Information
#
# Table name: ratings
#
#  id          :integer          not null, primary key
#  rating      :decimal(, )
#  comment     :text
#  user_id     :integer
#  rated_on_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  status      :integer          default(0), not null
#

class Rating < ApplicationRecord

  enum status: [:active, :reported, :censored, :allowed]
  belongs_to :user # rated by
  belongs_to :rated_on, class_name: "User", foreign_key: "rated_on_id"
  belongs_to :job
  has_many :reported_ratings, dependent: :destroy

  validates_presence_of :rating, :user_id, :rated_on_id, :status
  validates_presence_of :job_id, if: "user_id.present? && rated_on_id.present? && user.staff? && rated_on.customer?"
  validates :rating, inclusion: { in: 0..5 }
  validate :check_24_hr_throttle, on: :create, if: "user_id.present? && rated_on_id.present?"
  validates_uniqueness_of :rated_on_id, :scope => [:user_id, :job_id],
                          if: "user_id.present? && rated_on_id.present? && user.staff? && rated_on.customer?",
                          message: "user already has a rating provided by you for this job."

  delegate :ban_with_comment, :enable_with_comment, :bannable, to: :user

  before_save :add_to_average_rating, if: Proc.new { |rating|
                                      rating.new_record? || (rating.status_changed? && rating.allowed?)
                                    }
  before_save :minus_from_average_rating, if: Proc.new { |rating|
                                          !rating.new_record? && rating.status_changed? && rating.censored?
                                        }


  def add_to_average_rating
    avg_rating = ((rated_on.rating * rated_on.number_of_ratings) + rating) / (rated_on.number_of_ratings + 1)
    self.rated_on.update_attributes(rating: avg_rating, number_of_ratings: rated_on.number_of_ratings + 1)
  end

  def minus_from_average_rating
    if self.rated_on.number_of_ratings == 1
      avg_rating = 0
    else
      avg_rating = ((rated_on.rating * rated_on.number_of_ratings) - rating) / (rated_on.number_of_ratings - 1)
    end
    self.rated_on.update_attributes(rating: avg_rating, number_of_ratings: rated_on.number_of_ratings - 1)
  end

  def check_24_hr_throttle
    if self.user.customer? && self.rated_on.staff? &&
        Rating.where("user_id = ? AND rated_on_id = ? AND created_at > ?", self.user_id, self.rated_on_id, Time.now.utc - 1.day).exists?
      self.errors.add(:one_day_throttle_limit, "does not allow more than 1 comment in 24 hours.")
    end
  end
end
