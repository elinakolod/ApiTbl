module Jwt::Operation
  class Encode < Trailblazer::Operation
    step Contract::Build(constant: Jwt::Contract::Encode)
    step Contract::Validate(), fail_fast: true
    step :set_expiration_date!
    step :encode_token!

    def set_expiration_date!(options, params:, **)
      params[:payload].store(:exp, options['contract.default'].expiration)
    end

    def encode_token!(options, params:, **)
      token = JWT.encode(
        params[:payload],
        Rails.application.credentials[:secret_key_base],
        'HS256'
      )
      options[:token] = token
    end
  end
end
