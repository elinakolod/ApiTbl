module Api
  module V1
    module Tasks::Operation
      class Destroy < Trailblazer::Operation
        step Model(Task, :find_by)
        #step Policy::Pundit(TaskPolicy, :destroy?)
        step :destroy!

        def destroy!(_ctx, model:, **)
          model.destroy
        end
      end
    end
  end
end
