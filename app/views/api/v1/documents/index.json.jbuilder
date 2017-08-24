if @documents.present?
  json.documents @documents do |document|
    json.extract! document, :id,:name, :document, :project, :document_category
  end
end
