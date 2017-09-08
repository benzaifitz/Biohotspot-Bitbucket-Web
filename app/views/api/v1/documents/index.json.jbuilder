if @documents.present?
  @documents.each do |k, v|
    json.set! k do
      json.array!(v)do |document|
        json.partial! "api/v1/documents/document", document: document
        json.set! 'projects' do
          json.array!(document[:projects]) do |project|
            json.partial! "api/v1/documents/project", project: project
          end
        end
      end
    end
  end
end
