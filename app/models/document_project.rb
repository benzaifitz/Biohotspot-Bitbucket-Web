class DocumentProject < ApplicationRecord
  belongs_to :document
  belongs_to :project
end
