class Api::V1::Comments::Operation::Create < Trailblazer::Operation
  step Contract::Build(constant: Api::V1::Comments::Contract::Create)
  step Contract::Validate(key: :comment)
  step Contract::Persist()
end
