module Api
  module V1
    module Projects::Operation
      class RendererOptions
        extend Uber::Callable

        def self.call(ctx, **)
          ctx[:renderer_options] = {
            class: {
              Project: Api::V1::Projects::Representer::Project,
              User: Api::V1::Users::Representer::Authentication
            },
            include: [:user, tasks: [:comments]]
          }
        end
      end
    end
  end
end
