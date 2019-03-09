module Api
  module V1
    module Users::Representer
      class Authentication < JSONAPI::Serializable::Resource
        type 'users'

        attributes :email, :first_name, :last_name
      end
    end
  end
end
