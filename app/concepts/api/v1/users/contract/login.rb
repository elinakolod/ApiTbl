module Api::V1::Users::Contract
  class Login < Reform::Form
    include Dry

    with_options virtual: true do
      property :email
      property :password
    end

    validation do
      required(:email).filled(format?: Constants::Shared::EMAIL_REGEX)
      required(:password).filled
    end
  end
end
