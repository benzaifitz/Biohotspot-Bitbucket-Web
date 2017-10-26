class SiteCategory < ApplicationRecord
  belongs_to :category
  belongs_to :site
end
