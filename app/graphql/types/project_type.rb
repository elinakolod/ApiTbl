module Types
  class ProjectType < Types::BaseObject
    field :name, String, null: false
    field :created_at, String, null: false
    field :tasks, [Types::TaskType], null: true
  end
end
