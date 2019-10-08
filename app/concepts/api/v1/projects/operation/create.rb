module Api
  module V1
    module Projects::Operation
      class Create < Trailblazer::Operation
        step Model(Project, :new)
        step :set_user
        step Policy::Pundit(ProjectPolicy, :create?)
        step Contract::Build(constant: Projects::Contract::Create)
        step Contract::Validate()
        step Contract::Persist()
        step Projects::Operation::RendererOptions

        def set_user(_ctx, model:, user:, **)
          model.user = user
        end
      end
    end
  end
end
