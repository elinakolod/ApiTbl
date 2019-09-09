module Api::V1::Users::Contract
  class Create < Reform::Form
    include Dry

    property :email
    property :password
    property :password_confirmation

    validation :default do
      required(:email).filled(format?: Constants::Shared::EMAIL_REGEX)
      required(:password).filled(
        :str?,
        min_size?: Constants::Shared::PASSWORD_MIN_LENGTH,
        format?: Constants::Shared::PASSWORD_REGEX
      ).confirmation
    end

    validation :email_unique, if: :default do
      configure do
        config.messages = :i18n
        config.namespace = :user

        def email_unique?(email)
          User.where(email: email).empty?
        end
      end

      required(:email).filled(:email_unique?)
    end
  end
end
