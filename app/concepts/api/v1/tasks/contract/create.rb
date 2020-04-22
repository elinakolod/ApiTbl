module Api
  module V1
    module Tasks::Contract
      class Create < Reform::Form
        include Dry

        property :name
        property :project_id

        validation :default do
          required(:name).filled(:str?)
          required(:project_id).filled(:int?)
        end

        validation :existed_project, if: :default do
          configure do
            def existed_project?(value)
              Project.find_by(id: value)
            end
          end

          required(:project_id, &:existed_project?)
        end
      end
    end
  end
end
