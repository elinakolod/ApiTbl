module JsonApi
  class ErrorsConverter
    def initialize(messages:)
      @messages = messages
    end

    def call
      { errors: packed_errors }
    end

    private

    def packed_errors
      @messages.map do |key, values|
        values.map do |error_message|
          {
            title: key.to_s.humanize,
            detail: error_message.to_s
          }
        end
      end.flatten
    end
  end
end
