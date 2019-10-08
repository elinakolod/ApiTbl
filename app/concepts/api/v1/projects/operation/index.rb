module Api
  module V1
    module Projects::Operation
      class Index < Trailblazer::Operation
        step :fetch_collection!
        step Projects::Operation::RendererOptions

        def fetch_collection!(_ctx, current_user:, **)
          ctx[:model] = current_user.projects
        end
      end
    end
  end
end
