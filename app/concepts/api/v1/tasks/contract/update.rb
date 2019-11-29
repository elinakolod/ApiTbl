module Api
  module V1
    module Tasks::Contract
      class Update < Reform::Form
        include Dry

        property :name
        property :done

        validation do
          optional(:name).filled(:str?)
          optional(:done).filled(:bool?)
        end
      end
    end
  end
end
