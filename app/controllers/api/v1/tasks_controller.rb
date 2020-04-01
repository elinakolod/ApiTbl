module Api
  module V1
    class TasksController < ApplicationController
      #before_action :authenticate_user!

      def create
        endpoint operation: Tasks::Operation::Create, options: { current_user: current_user }
      end

      def update
        endpoint operation: Tasks::Operation::Update, options: { current_user: current_user }
      end

      def destroy
        Task.find(params[:id]).destroy
        head :no_content
      end
    end
  end
end
