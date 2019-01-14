module Api
  module V1
    class DocumentsController < ApiController
      before_action :authenticate_user!
      before_action :set_document, only: [:show, :destroy]

      api :GET, '/documents.json', 'Return all documents'
      param :project_id, String, desc: 'ID of project whose documents to be returned', required: true
      def index
        render json: category_documents
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

      def category_documents
        if params[:project_id]
          CategoryDocument.where(project_id: params[:project_id]).all.map{|a| {"#{a.name}" => a.documents}}            
        end  
      end  
    end
  end
end

