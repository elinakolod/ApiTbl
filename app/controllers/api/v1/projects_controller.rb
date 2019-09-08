module Api
  module V1
    class ProjectsController < ApplicationController
      def create
        endpoint operation: Projects::Operation::Create, options: { params: params }
      end

      def destroy
        Project.find(params[:id]).destroy
        head :no_content
      end
    end
  end
end
