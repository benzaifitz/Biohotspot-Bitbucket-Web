class Document < ApplicationRecord
  belongs_to :category_document
  belongs_to :project
  mount_uploader :document, DocumentUploader
  validates_presence_of :name, :category_document, :project, :document
end
