module Types
  class ProjectType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :created_at, String, null: false
    field :user, Types::UserType, null: false
    field :tasks, [Types::TaskType], null: false
    field :tasks_count, Integer, null: true

    def tasks_count
      object.tasks.size
    end
  end
end
