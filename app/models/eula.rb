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

class Eula < ActiveRecord::Base
  has_many :users
end
