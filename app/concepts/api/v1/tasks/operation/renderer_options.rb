module Api
  module V1
    module Tasks::Operation
      class RendererOptions
        extend Uber::Callable

        def self.call(ctx, **)
          ctx[:renderer_options] = {
            class: {
              Task: Api::V1::Tasks::Representer::Task,
              Project: Api::V1::Projects::Representer::Project,
              Comment: Api::V1::Comments::Representer::Comment
            },
            include: [:project, :comments]
          }
        end
      end
    end
  end
end
