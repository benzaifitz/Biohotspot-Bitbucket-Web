if @documents.present?
  @documents.each do |k, v|
    json.set! k do
      json.array!(v)do |document|
        json.extract! document, :id,:name, :document, :document_category
        json.set! 'projects' do
          json.array!(document[:projects]) do |project|
            json.extract! project, :id, :title, :created_at
          end
        end
      end
    end
  end
end
