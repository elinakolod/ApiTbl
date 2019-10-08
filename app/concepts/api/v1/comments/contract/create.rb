module Api
  module V1
    module Comments::Contract
      class Create < Reform::Form
        include Dry

        property :body
        property :task_id

        validation do
          required(:body).filled(:str?)
          required(:task_id).filled(:int?)
        end
      end
    end
  end
end
