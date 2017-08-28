if @documents.present?
  json.documents @documents do |document|
    json.extract! document, :id,:name, :document, :project, :document_category
  end
end

if @category_documents.present?
  json.category_documents @category_documents do |category_document|
    json.extract! category_document, :id, :name
  end
end