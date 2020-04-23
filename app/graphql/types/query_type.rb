module Types
  class QueryType < Types::BaseObject
    field :user, UserType, null: true
    field :find_users_by_first_name, [Types::UserType], null: true do
      argument :name, String, required: true
    end
    field :find_users_by_last_name, [Types::UserType], null: true do
      argument :name, String, required: true
    end
    field :search_user_full_text, [Types::UserType], null: true do
      argument :string, String, required: true
    end
    field :find_projects_by_task_name, [Types::ProjectType], null: true do
      argument :task_name, String, required: true
    end
    field :task_name_autocomplete, [Types::TaskType], null: true do
      argument :name_prefix, String, required: true
    end
    field :task_name_stemming_search, [Types::TaskType], null: true do
      argument :name, String, required: true
    end
    field :task_name_filter, [Types::TaskType], null: true do
      argument :name, String, required: true
    end
    field :comment_search, String, null: true do
      argument :string, String, required: true
    end

    def user
      context[:current_user]
    end

    def find_users_by_first_name(name:)
      User.search_by_name(:first_name, name)
    end

    def find_users_by_last_name(name:)
      User.search_by_name(:last_name, name)
    end

    def search_user_full_text(string:)
      User.search_user_full_text(string)
    end

    def find_projects_by_task_name(task_name:)
      Project.search_by_task(task_name)
    end

    def task_name_stemming_search(name:)
      Task.stemming_search(name)
    end

    def task_name_filter(name:)
      Task.name_filter(name)
    end

    def comment_search(string:)
      Comment.search_any_word(string).with_pg_search_highlight.first.pg_search_highlight
    end
  end
end
