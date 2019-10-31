module Api
  module V1
    module Tasks::Representer
      class Task < JSONAPI::Serializable::Resource
        type 'tasks'

        belongs_to :project, serializer: Projects::Representer::Project
        has_many :comments, serializer: Comments::Representer::Comment

        attributes :name, :done, :project_id
      end
    end
  end
end
