module Api
  module V1
    module Tasks::Operation
      class Create < Trailblazer::Operation
        step Model(Task, :new)
        step :set_project
        #step Policy::Pundit(TaskPolicy, :create?)
        step Contract::Build(constant: Tasks::Contract::Create)
        step Contract::Validate()
        step Contract::Persist()
        step Api::V1::Tasks::Operation::RendererOptions

        def set_project(_ctx, model:, params:, **)
          model.project_id = params[:project_id]
        end
      end
    end
  end
end
