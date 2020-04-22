module Types
  class QueryType < Types::BaseObject
    field :user, UserType, null: true

    def user
      context[:current_user]
    end
  end
end
