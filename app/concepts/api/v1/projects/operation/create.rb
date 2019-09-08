class Api::V1::Projects::Operation::Create < Trailblazer::Operation
  step Contract::Build(constant: Api::V1::Projects::Contract::Create)
  step Contract::Validate(key: :project)
  step Contract::Persist()
end
