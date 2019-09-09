module Api::V1::Projects::Lib
  class RendererOptions
    extend Uber::Callable

    def self.call(options, **)
      options[:renderer_options] = {
        class: {
          User: Api::V1::Projects::Representer::Project
        }
      }
    end
  end
end
