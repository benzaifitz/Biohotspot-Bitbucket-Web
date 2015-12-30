# == Schema Information
#
# Table name: privacies
#
#  id           :integer          not null, primary key
#  privacy_text :text
#  is_latest    :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Privacy < ActiveRecord::Base
  after_create :set_is_latest_for_old_records

  private

  def set_is_latest_for_old_records
    Privacy.where('id != ?', self.id).update_all(is_latest: false)
  end
end
