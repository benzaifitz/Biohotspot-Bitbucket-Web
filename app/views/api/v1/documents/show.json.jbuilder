if @document.present?
  json.extract! @document, :id,:name, :document, :project, :document_category
end
