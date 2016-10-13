# == Schema Information
#
# Table name: eulas
#
#  id         :integer          not null, primary key
#  eula_text  :text
#  is_latest  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Eula < ApplicationRecord
  has_many :users

  after_create :set_is_latest_for_old_records

  private

  def set_is_latest_for_old_records
    Eula.where('id != ?', self.id).update_all(is_latest: false)
  end
end
