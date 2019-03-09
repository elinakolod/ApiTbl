module Api::V1::Users::Lib
  class RendererOptions
    extend Uber::Callable

    def self.call(options, **)
      options[:renderer_options] = {
        class: {
          User: Api::V1::Users::Representer::Authentication
        }
      }
    end
  end
end
