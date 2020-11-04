class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection
  include SimpleEndpoint::Controller
  include JWTSessions::RailsAuthorization
  include Pundit
  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

  private

  def current_user
    token = request_cookies[JWTSessions.cookie_by(:access)]
    @current_user ||= User.find(payload['user_id']) if token.present?
  end

  def default_handler
    {
      destroyed: ->(_result) { head :no_content },
      created: ->(result) { render jsonapi: result[:model], **result[:renderer_options], status: :created },
      success: ->(result) { render jsonapi: result[:model], **result[:renderer_options], status: :ok },
      forbidden: ->(_result) { render json: { errors: [{ title: 'Forbidden', detail: 'Access Denied' }] }, status: :forbidden },
      not_found: ->(_result) { head :not_found },
      unauthorized: ->(result) { render json: json_api_errors(result['contract.default'].errors.messages), status: :unauthorized },
      invalid: ->(result) { render json: result['contract.default'].errors.messages, status: :unprocessable_entity }
    }
  end

  def default_cases
    {
      destroyed: ->(result) { result.success? && result[:model].respond_to?(:destroyed?) && result[:model].destroyed? },
      created: ->(result) { result.success? && result['model.action'] == :new },
      success: ->(result) { result.success? },
      forbidden: ->(result) { result.failure? && result['result.policy.default'] && result['result.policy.default'].failure? },
      not_found: ->(result) { result.failure? && result[:model].blank? },
      invalid: ->(result) { result.failure? }
    }
  end

  def json_api_errors(messages)
    JsonApi::ErrorsConverter.new(messages: messages).call
  end

  def not_authorized
    render json: { error: 'Not authorized' }, status: :unauthorized
  end
end
