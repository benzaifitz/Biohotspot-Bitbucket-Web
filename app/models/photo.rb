class Photo < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  mount_uploader :file, PhotoUploader
  validates :file,
            :file_size => {
                :maximum => 2.0.megabytes.to_i
            }
  # belongs_to :category
end
