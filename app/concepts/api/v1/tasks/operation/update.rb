module Api
  module V1
    module Tasks::Operation
      class Update < Trailblazer::Operation
        step Model(Task, :find_by)
        step Policy::Pundit(TaskPolicy, :update?)
        step Contract::Build(constant: Tasks::Contract::Update)
        step Contract::Validate()
        step Contract::Persist()
        step Api::V1::Tasks::Operation::RendererOptions
      end
    end
  end
end
