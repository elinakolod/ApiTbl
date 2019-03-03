module Jwt::Contract
  class Decode < Reform::Form
    include Dry

    property :token, virtual: true

    validation do
      required(:token).filled(:str?)
    end
  end
end
