module Api::V1::Users::Operation
  class Login < Trailblazer::Operation
    step Contract::Build(constant: Api::V1::Users::Contract::Login)
    step Contract::Validate(), fail_fast: true
    step :find
    step :authenticate!
    fail :errors!
    step Api::V1::Users::Lib::GenerateToken
    step Api::V1::Users::Lib::RendererOptions

    def find(options, params:, **)
      options[:model] = User.find_by(email: params[:email])
    end

    def authenticate!(options, params:, **)
      options[:model].authenticate(params[:password])
    end

    def errors!(options, params:, **)
      options['contract.default'].errors.add(:user, 'fucking shit')
    end
  end
end
