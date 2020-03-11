module Types
  class TaskType < Types::BaseObject
    field :name, String, null: false
    field :done, Boolean, null: false
    field :project, Types::ProjectType, null: false
    field :comments, [Types::CommentType], null: true
  end
end
