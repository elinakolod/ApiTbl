class Api::V1::Projects::Contract::Create < Reform::Form
  include Dry

  property :name

  validation do
    required(:name).filled(:str?)
  end
end
