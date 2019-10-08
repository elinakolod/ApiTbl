module Api
  module V1
    module Projects::Operation
      class Update < Trailblazer::Operation
        step :find_project
        step Policy::Pundit(ProjectPolicy, :update?)
        step Contract::Build(constant: Projects::Contract::Create)
        step Contract::Validate()
        step :update_project
        step Api::V1::Projects::Operation::RendererOptions

        def find_project(ctx, params:, user:, **)
          ctx[:model] = user.projects.find(params[:id])
        end

        def update_project(_ctx, model:, params:, **)
          model.update(name: params[:project][:name])
        end
      end
    end
  end
end
