class LandManagerSubCategory < ApplicationRecord
  belongs_to :sub_category
  belongs_to :land_manager, class_name: 'LandManager', foreign_key: 'land_manager_id'
end
