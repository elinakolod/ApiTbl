module Api::V1
  class UsersController < ApplicationController
    def create
      endpoint operation: Users::Operation::Create,
               before_response: user_response_handler
    end

    def login
      endpoint operation: Users::Operation::Login,
               before_response: user_response_handler
    end

    private

    def user_response_handler
      {
        success: -> (result) {
          response.headers['Authorization'] = result[:json_web_token]
        }
      }
    end
  end
end
