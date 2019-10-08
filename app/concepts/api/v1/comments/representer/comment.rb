module Api
  module V1
    module Comments::Representer
      class Comment < JSONAPI::Serializable::Resource
        type 'comments'

        belongs_to :task, serializer: Tasks::Representer::Task

        attributes :body, :created_at
      end
    end
  end
end
