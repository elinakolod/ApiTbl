module Types
  class TaskType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :done, Boolean, null: false
    field :created_at, String, null: false
    field :project, Types::ProjectType, null: false
    field :comments, [Types::CommentType], null: false
    field :comments_count, Integer, null: false

    def comments_count
      object.comments.size
    end
  end
end
