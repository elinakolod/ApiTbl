module Jwt::Operation
  class Decode < Trailblazer::Operation
    step Contract::Build(constant: Jwt::Contract::Decode)
    step Contract::Validate()
    step :decode_token!

    def decode_token!(options, params:, **)
      body = JWT.decode(
        params[:token],
        Rails.application.credentials[:secret_key_base],
        true,
        algorithm: 'HS256'
      ).first
      options[:decoded_body] = HashWithIndifferentAccess.new body
    end
  end
end
