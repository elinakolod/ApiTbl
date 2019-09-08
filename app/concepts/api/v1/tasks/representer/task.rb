module Api
  module V1
    module Tasks::Representer
      class Task < JSONAPI::Serializable::Resource
        type 'task'
        attributes :id, :name, :done
        has_many :comments
      end
    end
  end
end
