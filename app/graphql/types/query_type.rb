module Types
  class QueryType < Types::BaseObject
    field :user, UserType, null: true

    field :search, [Types::SearchSubject], null: true do
      argument :string, String, required: true
    end

    def user
      context[:current_user]
    end

    def search(string:)
      Elasticsearch::Model.search(string, [Project, Comment, Task], size: 50).records.to_a
    end
  end
end
