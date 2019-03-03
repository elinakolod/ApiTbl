module Api::V1
  class UsersController < ApplicationController
    def create
      run Users::Operation::Create do |result|
        response.headers['Authorization'] = result[:json_web_token]
        return head :ok
      end

      render json: json_api_errors(result['contract.default'].errors.messages),
             status: :unprocessable_entity
    end
  end
end
