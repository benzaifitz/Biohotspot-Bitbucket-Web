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

  def deprecate!
    self.is_latest = false
    self.save!
  end
end
