module Api
  module V1
    class TasksController < ApplicationController
      before_action :authorize_access_request!

      def create
        endpoint operation: Tasks::Operation::Create, options: { params: params }
      end

      def update
        endpoint operation: Tasks::Operation::Update, options: { params: params }
      end

      def destroy
        Task.find(params[:id]).destroy
        head :no_content
      end
    end
  end
end
