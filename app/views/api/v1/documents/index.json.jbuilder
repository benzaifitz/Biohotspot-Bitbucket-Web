if @documents.present?
  @documents.each do |k, v|
    json.set! k do
      json.array!(v)do |document|
        json.extract! document, :id,:name, :document, :project, :document_category
      end
    end
  end
end
