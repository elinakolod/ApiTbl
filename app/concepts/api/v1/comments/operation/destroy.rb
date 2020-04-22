module Api
  module V1
    module Comments::Operation
      class Destroy < Trailblazer::Operation
        step Model(Comment, :find_by)
        step Policy::Pundit(CommentPolicy, :destroy?)
        step :destroy!

        def destroy!(_ctx, model:, **)
          model.destroy
        end
      end
    end
  end
end
