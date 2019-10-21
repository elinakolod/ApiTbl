module Api
  module V1
    module Tasks::Representer
      class Task < JSONAPI::Serializable::Resource
        type 'task'

        belongs_to :project, serializer: Projects::Representer::Project
        has_many :comments, serializer: Comments::Representer::Comment

        attributes :name, :done
      end
    end
  end
end
