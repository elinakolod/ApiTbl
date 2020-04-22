module Api
  module V1
    module Projects::Operation
      class Destroy < Trailblazer::Operation
        step Model(Project, :find_by)
        step Policy::Pundit(ProjectPolicy, :destroy?)
        step :destroy!

        def destroy!(_ctx, model:, **)
          model.destroy
        end
      end
    end
  end
end
