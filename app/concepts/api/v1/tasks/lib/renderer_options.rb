module Api::V1::Tasks::Lib
  class RendererOptions
    extend Uber::Callable

    def self.call(options, **)
      options[:renderer_options] = {
        class: {
          User: Api::V1::Tasks::Representer::Task
        }
      }
    end
  end
end
