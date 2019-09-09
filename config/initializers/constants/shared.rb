module Constants
  module Shared
    EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i.freeze
    PASSWORD_MIN_LENGTH = 6
    PASSWORD_REGEX = /\A(?=\S*?[A-Z])(?=\S*?[a-z])(?=\S*?[0-9])\S{8,}\z/.freeze
  end
end
