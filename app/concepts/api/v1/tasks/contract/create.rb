class Api::V1::Tasks::Contract::Create < Reform::Form
  include Dry

  property :name
  property :project_id

  validation do
    required(:name).filled(:str?)
    required(:project_id).filled(:int?)
  end
end
