module Api::V1
  class UsersController < ApplicationController
    def create
      endpoint operation: Users::Operation::Create, &user_response_handler
    end

    def login
      endpoint operation: Users::Operation::Login, &user_response_handler
    end

    private

    def user_response_handler
      -> (kase, result) do
        case kase
        when :success
          response.headers['Authorization'] = result[:json_web_token]
        end
      end
    end
  end
end
