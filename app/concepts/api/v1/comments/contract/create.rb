class Api::V1::Comments::Contract::Create < Reform::Form
  include Dry

  property :body

  validation do
    required(:body).filled(:str?)
  end
end
