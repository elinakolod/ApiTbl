module Api
  module V1
    class TasksController < ApplicationController
      def create
        endpoint operation: Tasks::Operation::Create, options: { params: params }
      end

      def update
        endpoint operation: Tasks::Operation::Update, options: { params: params }
      end

      def destroy
        Task.find(params[:id]).destroy
      end
    end
  end
end
