module Api
  module V1
    module Tasks::Representer
      class Task < JSONAPI::Serializable::Resource
        type 'task'

        attributes :name, :done
      end
    end
  end
end
