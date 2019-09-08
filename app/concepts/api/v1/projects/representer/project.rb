module Api
  module V1
    module Projects::Representer
      class Project < JSONAPI::Serializable::Resource
        type 'projects'
        attributes :id, :name, :created_at
        has_many :tasks
      end
    end
  end
end
