module Api
  module V1
    class PagesController < ApiController
      before_action :authenticate_user!

      # GET /api/v1/land_managers/about.json
      api :GET, '/land_managers/about.json', 'Show about page.'
      # param :id, Integer, desc: 'ID of land_manager to be shown.', required: true
      def about
        @documents = Document.all.map{|a| {id: a.id, name: a.name, document: "#{request.protocol}#{request.host_with_port}#{a.document.url}", project: a.try(:project).try(:title), document_category: a.try(:category_document).try(:name)}}
        @category_documents = CategoryDocument.all
      end

    end
  end
end

