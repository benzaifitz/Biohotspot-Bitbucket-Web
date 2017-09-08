class Document < ApplicationRecord
  belongs_to :category_document
  has_many :document_projects
  has_many :projects, :through => :document_projects
  accepts_nested_attributes_for :document_projects, :allow_destroy => true
  mount_uploader :document, DocumentUploader
  validates_presence_of :name, :category_document, :document
end
