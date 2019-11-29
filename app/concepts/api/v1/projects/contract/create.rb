module Api
  module V1
    module Projects::Contract
      class Create < Reform::Form
        include Dry

        property :name

        validation do
          required(:name).filled(:str?)
        end
      end
    end
  end
end
