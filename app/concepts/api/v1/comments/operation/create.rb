module Api
  module V1
    module Comments::Operation
      class Create < Trailblazer::Operation
        step Model(Comment, :new)
        step :set_task
        step Policy::Pundit(CommentPolicy, :create?)
        step Contract::Build(constant: Comments::Contract::Create)
        step Contract::Validate()
        step Contract::Persist()
        step Comments::Operation::RendererOptions

        def set_task(_ctx, model:, params:, **)
          model.task_id = params[:task_id]
        end
      end
    end
  end
end
