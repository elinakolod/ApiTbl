module Api
  module V1
    module Comments::Operation
      class RendererOptions
        extend Uber::Callable

        def self.call(ctx, **)
          ctx[:renderer_options] = {
            class: {
              Comment: Api::V1::Comments::Representer::Comment,
              Task: Api::V1::Tasks::Representer::Task
            },
            include: [:task]
          }
        end
      end
    end
  end
end
