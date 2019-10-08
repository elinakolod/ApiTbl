module Api
  module V1
    module Tasks::Contract
      class Create < Reform::Form
        include Dry

        property :name
        property :project_id

        validation do
          required(:name).filled(:str?)
          required(:project_id).filled(:int?)
        end
      end
    end
  end
end
