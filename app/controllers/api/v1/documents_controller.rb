module Api
  module V1
    class DocumentsController < ApiController
      before_action :authenticate_user!
      before_action :set_document, only: [:show, :destroy]

      api :GET, '/documents.json', 'Return all documents'
      def index
        @documents = Document.all.map{|a| show_data(a)}.group_by{|a| a[:document_category]}
      end

      api :GET, '/documents/:id.json', 'Return single document'
      def show
        @document = show_data(@document)
      end

      api :DELETE, '/documents/:id.json', 'Delete single document'
      def destroy
        @document.destroy
        render json: {success: true, status: 200}
      end

      private
      def set_document
        @document = Document.find(params[:id])
      end

      def show_data data
        {id: data.id, name: data.name, document: "#{request.protocol}#{request.host_with_port}#{data.document.url}",
         projects: data.try(:projects), document_category: data.try(:category_document).try(:name)}
      end
    end
  end
end

