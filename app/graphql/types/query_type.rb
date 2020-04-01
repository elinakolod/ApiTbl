module Types
  class QueryType < Types::BaseObject
    field :user, UserType, null: true do
      argument :id, ID, required: true
    end

    def user(id:)
      User.find(id)
    end
  end
end
