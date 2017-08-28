class Photo < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  mount_uploader :file, PhotoUploader
  # belongs_to :category
end
