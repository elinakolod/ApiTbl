module Api
  module V1
    module Tasks::Contract
      class Update < Reform::Form
        include Dry

        property :name
        property :done

        validation do
          required(:name).filled(:str?)
          required(:done).filled(:bool?)
        end
      end
    end
  end
end
