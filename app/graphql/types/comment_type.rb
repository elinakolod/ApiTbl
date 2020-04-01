module Types
  class CommentType < Types::BaseObject
    field :id, ID, null: false
    field :body, String, null: false
    field :created_at, String, null: false
    field :task, Types::TaskType, null: false
  end
end
