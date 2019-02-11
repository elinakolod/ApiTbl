module Api
  module V1
    module Users
      module Operation
        class Create < Trailblazer::Operation
          step Model(User, :new)
          step self::Contract::Build(constant: Users::Contract::Create)
          step self::Contract::Validate()
          step self::Contract::Persist()

          def send_confirmation
            redirect_to = ctx['contract.default'].redirect_to
            UserMailer.confirmation(model, redirect_to).deliver_later
          end
        end
      end
    end
  end
end
