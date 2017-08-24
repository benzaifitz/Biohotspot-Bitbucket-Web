module Api
  module V1
    class DocumentsController < ApiController
      before_action :authenticate_user!

      api :GET, '/documents.json', 'Return all documents'
      def index
        @documents = Document.all.map{|a| {id: a.id, name: a.name, document: "#{request.host_with_port}#{a.document.url}", project: a.try(:project).try(:title), document_category: a.try(:category_document).try(:name)}}.sort_by{|a| a[:name]}
      end

      private

    end
  end
end

