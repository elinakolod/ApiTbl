module Api
  module V1
    class CommentsController < ApplicationController
      def create
        endpoint operation: Comments::Operation::Create, options: { params: params }
      end

      def destroy
        Comment.find(params[:id]).destroy
        head :no_content
      end
    end
  end
end
