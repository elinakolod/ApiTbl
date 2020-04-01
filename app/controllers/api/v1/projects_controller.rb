module Api
  module V1
    class ProjectsController < ApplicationController
      #before_action :authenticate_user!

      def index
        endpoint operation: Projects::Operation::Index,
                 options: { current_user: current_user }
      end

      def create
        endpoint operation: Projects::Operation::Create,
                 options: { current_user: current_user }
      end

      def update
        endpoint operation: Projects::Operation::Update,
                 options: { current_user: current_user }
      end

      def destroy
        endpoint operation: Projects::Operation::Destroy,
                 options: { current_user: current_user }
      end
    end
  end
end
