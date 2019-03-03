module Api::V1::Users::Lib
  class GenerateToken
    extend Uber::Callable

    def self.call(options, **)
      payload = { payload: { user_id: options[:model].id } }
      result = Jwt::Operation::Encode.(params: payload)
      options[:json_web_token] = result[:json_web_token]
    end
  end
end
