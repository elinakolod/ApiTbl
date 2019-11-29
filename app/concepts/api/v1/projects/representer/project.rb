module Api
  module V1
    module Projects::Representer
      class Project < JSONAPI::Serializable::Resource
        type 'projects'

        belongs_to :user, serializer: Users::Representer::Authentication
        has_many :tasks, serializer: Tasks::Representer::Task

        attributes :name, :created_at
      end
    end
  end
end
