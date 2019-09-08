class Api::V1::Tasks::Operation::Create < Trailblazer::Operation
  step Contract::Build(constant: Api::V1::Tasks::Contract::Create)
  step Contract::Validate(key: :task)
  step Contract::Persist()
end
