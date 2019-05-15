class ApplicationController < ActionController::API
  include SimpleEndpoint::Controller

  private

  def default_handler
    {
      success: -> (result) { render jsonapi: result[:model], **result[:renderer_options], status: :created },
      invalid: -> (result) { render json: json_api_errors(result['contract.default'].errors.messages), status: :unprocessable_entity }
    }
  end

  def default_cases
    {
      success:   -> (result) { result.success? },
      invalid:   -> (result) { result.failure? },
      destroyed: -> (result) { result.success? && result["model.action"] == :destroy },
      not_found: -> (result) { result.failure? && result["result.model"] && result["result.model"].failure? },
      forbidden: -> (result) { result.failure? && result["result.policy.default"] && result["result.policy.default"].failure? }
    }
  end

  def json_api_errors(messages)
    JsonApi::ErrorsConverter.new(messages: messages).call
  end
end
