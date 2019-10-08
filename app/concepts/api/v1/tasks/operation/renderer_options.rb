module Api
  module V1
    module Tasks::Operation
      class RendererOptions
        extend Uber::Callable

        def self.call(ctx, **)
          ctx[:renderer_options] = {
            class: {
              Task: Api::V1::Tasks::Representer::Task
            }
          }
        end
      end
    end
  end
end
