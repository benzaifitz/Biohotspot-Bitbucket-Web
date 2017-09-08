if @document.present?
  json.extract! @document, :id,:name, :document, :project, :document_category
  json.set! 'projects' do
    json.array!(@document.projects) do |project|
      json.extract! project, :id, :title, :created_at
    end
  end
end
