module Api
  module V1
    module Users
      module Contract
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

          validation :unique, if: :default do
            configure do
              config.messages = :i18n
              config.namespace = :user

              def unique?(attr_name, value)
                record.class.where.not(id: record.id).where(attr_name => value).empty?
              end
            end

            required(:email).filled(unique?: :email)
          end
        end
      end
    end
  end
end
