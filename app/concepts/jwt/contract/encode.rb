
module Jwt::Contract
  class Encode < Reform::Form
    include Dry

    with_options virtual: true do
      property :payload
      property :expiration, default: 24.hours.from_now.to_i
    end

    validation do
      required(:payload).filled(:hash?)
      required(:expiration).filled(:int?, gt?: Time.current.to_i)
    end
  end
end
